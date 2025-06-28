#!/bin/bash
set -euo pipefail

### === CONFIG ===
IPSET_NAME="blacklist"
WORKDIR="/etc/ipsets"
TMPDIR="${WORKDIR}/tmp"
BLOCKLIST="${WORKDIR}/${IPSET_NAME}.zone"
CUSTOM="${WORKDIR}/custom.zone"
SAVEFILE="${WORKDIR}/${IPSET_NAME}.save"
LOGFILE="/var/log/ipset-update.log"
EXCLUDE=("us.zone" "gb.zone" "nl.zone" "as.zone" "aq.zone" "au.zone" "at.zone" "be.zone" "ca.zone" "dk.zone" "fr.zone" "de.zone" "gr.zone" "is.zone" "ie.zone" "it.zone" "no.zone" "se.zone" "ch.zone" "ua.zone" "vg.zone" "vi.zone" "zz.zone")
TARBALL_URL="https://www.ipdeny.com/ipblocks/data/countries/all-zones.tar.gz"

### === LOGGING ===
log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
  echo "$msg"
  echo "$msg" >> "$LOGFILE"
}

### === PREP ===
mkdir -p "$TMPDIR"
touch "$LOGFILE"
log "Starting update of IPSet '$IPSET_NAME'."

### === FETCH AND FILTER ===
log "Downloading country blocklist tarball..."
curl --http1.1 -sSL "$TARBALL_URL" -o "$TMPDIR/all-zones.tar.gz"
tar -xzf "$TMPDIR/all-zones.tar.gz" -C "$TMPDIR"

for country in "${EXCLUDE[@]}"; do
  log "Excluding country zone: $country"
  rm -f "$TMPDIR/$country"
done

### === MERGE ZONE FILES ===
> "$BLOCKLIST"
cat "$TMPDIR"/*.zone >> "$BLOCKLIST"
if [[ -f "$CUSTOM" ]]; then
  cat "$CUSTOM" >> "$BLOCKLIST"
fi
log "Merged zone file size: $(du -h "$BLOCKLIST" | cut -f1)"

NUM_ENTRIES=$(grep -cve '^\s*$' -e '^\s*#' "$BLOCKLIST")
log "Total entries to load: $NUM_ENTRIES"

### === BUILD ipset-restore INPUT ===
RESTORE_FILE="${TMPDIR}/restore.txt"
echo "create tmp_${IPSET_NAME} hash:net family inet hashsize 8192 maxelem 500000" > "$RESTORE_FILE"
awk '!/^#/ && NF { print $1 }' "$BLOCKLIST" | sort -u | awk '{ print "add tmp_'$IPSET_NAME' " $1 }' >> "$RESTORE_FILE"

### === APPLY SET ATOMICALLY ===
log "Creating temporary IPSet and loading entries (this may take a moment)..."
ipset destroy tmp_${IPSET_NAME} 2>/dev/null || true
ipset restore < "$RESTORE_FILE"
log "Loaded IPSet 'tmp_${IPSET_NAME}' successfully."

# Swap and clean
if ! ipset list $IPSET_NAME &>/dev/null; then
  log "Set '$IPSET_NAME' does not exist. Creating it for the first time."
  ipset create $IPSET_NAME hash:net family inet hashsize 8192 maxelem 500000
fi

log "Swapping tmp_${IPSET_NAME} into place."
ipset swap tmp_${IPSET_NAME} $IPSET_NAME

ENTRIES=$(ipset list $IPSET_NAME | grep "Number of entries" || echo "unknown")
log "Swap complete. $IPSET_NAME now has: $ENTRIES"

log "Destroying tmp_${IPSET_NAME}"
ipset destroy tmp_${IPSET_NAME}

# === Ensure iptables rule exists
if ! iptables -C INPUT -m set --match-set $IPSET_NAME src -j DROP 2>/dev/null; then
  log "Adding iptables rule to DROP traffic from set '$IPSET_NAME'"
  iptables -I INPUT -m set --match-set $IPSET_NAME src -j DROP
  iptables-save | tee /etc/iptables/rules.v4 > /dev/null
  log "iptables rule saved to /etc/iptables/rules.v4"
else
  log "iptables rule for set '$IPSET_NAME' already exists, skipping."
fi

# Save for reboot
ipset save "$IPSET_NAME" > "$SAVEFILE"
log "Saved IPSet to $SAVEFILE"

# Clean up
rm -rf "$TMPDIR"
log "Cleanup complete. Update finished."

#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

echo "Verifying merged native multi-client implementation..."

git -C "${REPO_ROOT}" merge-base --is-ancestor "${REQUIRED_MERGE}" HEAD
grep -Fq 'QString sessionId;' "${REPO_ROOT}/qmlui/tardis/networkmanager.h"
grep -Fq 'QHash<QString, NetworkHost *> m_hostsMap;' "${REPO_ROOT}/qmlui/tardis/networkmanager.h"
grep -Fq 'QList<NativeAccessRequest> m_pendingAccessRequests;' "${REPO_ROOT}/qmlui/tardis/networkmanager.h"
grep -Fq 'setAllowAllNative(bool allow)' "${REPO_ROOT}/qmlui/tardis/networkmanager.h"
grep -Fq 'clientAccessRequestCancelled' "${REPO_ROOT}/qmlui/tardis/networkmanager.h"
grep -Fq 'clientAutoAuthorized' "${REPO_ROOT}/qmlui/tardis/networkmanager.h"
grep -Fq '"sa" << "server-allow-all"' "${REPO_ROOT}/qmlui/main.cpp"
grep -Fq 'bool enableNativeServer = parser.isSet(remoteOption) || allowAllNative;' "${REPO_ROOT}/qmlui/main.cpp"

echo "Merged PR #2094 verified at source level."
echo "Native clients are keyed per session, queued independently, and -sa/--server-allow-all enables the native server."

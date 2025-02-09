#!/usr/bin/env sh
set -eu

# shellcheck disable=SC2120,SC3043
replaceEnvSecrets() {
	# replaceEnvSecrets 1.0.0
	# https://gist.github.com/anthochamp/d4d9537f52e5b6c42f0866dd823a605f
	local prefix="${1:-}"

	for envSecretName in $(export | awk '{print $2}' | grep -oE '^[^=]+' | grep '__FILE$'); do
		if [ -z "$prefix" ] || printf '%s' "$envSecretName" | grep "^$prefix" >/dev/null; then
			local envName
			envName=$(printf '%s' "$envSecretName" | sed 's/__FILE$//')

			local filePath
			filePath=$(eval echo '${'"$envSecretName"':-}')

			if [ -n "$filePath" ]; then
				if [ -f "$filePath" ]; then
					echo Using content from "$filePath" file for "$envName" environment variable value.

					export "$envName"="$(cat -A "$filePath")"
					unset "$envSecretName"
				else
					echo ERROR: Environment variable "$envSecretName" is defined but does not point to a regular file. 1>&2
					exit 1
				fi
			fi
		fi
	done
}

replaceEnvSecrets UNBOUND_EXPORTER_

UNBOUND_EXPORTER_HOST=${UNBOUND_EXPORTER_HOST:-}
UNBOUND_EXPORTER_CA_FILE=${UNBOUND_EXPORTER_CA_FILE:-}
UNBOUND_EXPORTER_CERT_FILE=${UNBOUND_EXPORTER_CERT_FILE:-}
UNBOUND_EXPORTER_CERT_KEY_FILE=${UNBOUND_EXPORTER_CERT_KEY_FILE:-}

if [ -n "${1:-}" ]; then
	exec "$@"
fi

args=

if [ -n "$UNBOUND_EXPORTER_HOST" ]; then
	args=$args" -unbound.host '$UNBOUND_EXPORTER_HOST'"
fi

if [ -n "$UNBOUND_EXPORTER_CA_FILE" ]; then
	args=$args" -unbound.ca '$UNBOUND_EXPORTER_CA_FILE'"
fi

if [ -n "$UNBOUND_EXPORTER_CERT_FILE" ]; then
	args=$args" -unbound.cert '$UNBOUND_EXPORTER_CERT_FILE'"
fi

if [ -n "$UNBOUND_EXPORTER_CERT_KEY_FILE" ]; then
	args=$args" -unbound.key '$UNBOUND_EXPORTER_CERT_KEY_FILE'"
fi

eval "exec /unbound_exporter$args"

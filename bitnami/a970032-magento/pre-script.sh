#!/bin/bash
INFO "Execute custom command from $MAGNETO_PRE_SCRIPT"

if  [! -z "${MAGNETO_PRE_SCRIPT}"]; then
	INFO "executing MAGNETO_PRE_SCRIPT"
	eval $MAGNETO_PRE_SCRIPT
fi
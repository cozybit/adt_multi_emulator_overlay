# Goal: this scripts allows installing the ADT overlay in a more controlled
# way, supporint actions like install & restore.

[ "${DEBUG}" = "1" ] && set -x

# print message and exit the script
# usage: die <message>
function die () {
    echo "${*}"
    exit -1
}

# back-up original ADT files and install the custom ones.
function install () {
    echo Installing overlay in ADT...
    for dir in ${OVERLAY}; do
        _FILES=`find ${dir} -type f`
        for file in ${_FILES}; do
            if [ -f "${SDK_PATH}/${file}" ]; then
                cp ${SDK_PATH}/${file} ${SDK_PATH}/${file}.orig
                #cp ${file} ${SDK_PATH}/${file}
            fi
        done
    done
}

# restores original ADT files.
function restore () {
    echo Restoring the original ADT...
    _FILES=`find ${SDK_PATH} -type f -name *.orig`
    for file in ${_FILES}; do
        mv ${file} ${file/.orig/}
    done
}

SDK_PATH=${ANDROID_HOME}
OVERLAY="tools"
# parse the incoming parameters
usage="${0} [ -a <install/restore> ] [ -p <path_to_sdk> ] [-h ]"
while getopts "a:p:h" options; do
    case $options in
        a ) ACTION=${OPTARG};;
        p ) SDK_PATH=${OPTARG};;
        h ) echo "-a    action to execute: install/restore."
            echo "-p    path to the android SDK."
	    echo "      If env var ANDROID_HOME is defined, this parameter is not needed."
            echo "-h    print this message."
            echo ${usage}
            exit 0;;
        * ) echo unkown option: ${option}
            echo ${usage}
            exit 1;;
    esac
done

# verifying parameters 
[ -z "${SDK_PATH}" ] && die "ERROR: specify a valid path to the android sdk (-p) or define a valid ANROID_HOME evn var. Aborting."
[ ! -d "${SDK_PATH}" ] && die "ERROR: ${SDK_PATH} is not a valid directory. Aborting."
# get absolute path to the SDK.
SDK_PATH=$(readlink -f ${SDK_PATH})

# run the right action
if [ "${ACTION}" == "install" ]; then
   install
elif [ "${ACTION}" == "restore" ]; then
    restore
else
    die "ERROR: unkown action "${ACTION}". Please, provide a valid action: ${0} -a install/restore."
fi

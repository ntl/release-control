SOURCE_DIRECTORY=$1
STAGE_DIRECTORY=$2

cp -a -v $SOURCE_DIRECTORY/* $STAGE_DIRECTORY

cd $STAGE_DIRECTORY

chmod 755 ./install-gems.sh

./install-gems.sh

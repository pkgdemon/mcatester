#!/bin/sh

NAME="mcatester"
VERSION="12.3"

poudriere_jail()
{
  # Check if jail exists
  poudriere jail -l | grep -q ${NAME}
  if [ $? -eq 1 ] ; then
    # If jail does not exist create it
    poudriere jail -c -j ${NAME} -v ${VERSION}-RELEASE -K GENERIC
  else
    # Update jail if it exists
    poudriere jail -u -j ${NAME}
  fi
}

poudriere_ports()
{
  # Check if ports tree exists
  poudriere ports -l | grep -q ${NAME}
  if [ $? -eq 1 ] ; then
    # If ports tree does not exist create it
    poudriere ports -c -p ${NAME}_ports
  fi
}

poudriere_bulk()
{
  poudriere bulk -j ${NAME} -p ${NAME}_ports -f pkg-list
}

poudriere_image()
{
  poudriere image -t tar -j ${NAME} -p ${NAME}_ports -h ${NAME} -n ${NAME} -f pkg-list
}

poudriere_jail
poudriere_ports
poudriere_bulk
poudriere_image

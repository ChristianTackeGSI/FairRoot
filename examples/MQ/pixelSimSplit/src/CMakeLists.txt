 ################################################################################
 #    Copyright (C) 2014 GSI Helmholtzzentrum fuer Schwerionenforschung GmbH    #
 #                                                                              #
 #              This software is distributed under the terms of the             # 
 #              GNU Lesser General Public Licence (LGPL) version 3,             #  
 #                  copied verbatim in the file "LICENSE"                       #
 ################################################################################
# Create a library called "libPixel" which includes the source files given in
# the array .
# The extension is already found.  Any number of sources could be listed here.

set(INCLUDE_DIRECTORIES
  ${BASE_INCLUDE_DIRECTORIES}
  ${FairMQ_INCDIR}/fairmq/options
  ${CMAKE_SOURCE_DIR}/base/MQ/policies/Serialization
  ${CMAKE_SOURCE_DIR}/examples/MQ/pixelDetector/src
  ${CMAKE_SOURCE_DIR}/examples/MQ/pixelDetector/src/devices
  ${CMAKE_SOURCE_DIR}/examples/MQ/pixelSimSplit/src
  ${CMAKE_SOURCE_DIR}/examples/MQ/pixelSimSplit/src/devices
  ${CMAKE_SOURCE_DIR}/examples/common/mcstack
  ${FairLogger_INCDIR}
)


Set(SYSTEM_INCLUDE_DIRECTORIES
    ${SYSTEM_INCLUDE_DIRECTORIES}
)

include_directories( ${INCLUDE_DIRECTORIES})
Include_Directories(SYSTEM ${SYSTEM_INCLUDE_DIRECTORIES})

set(LINK_DIRECTORIES
${ROOT_LIBRARY_DIR}
${Boost_LIBRARY_DIRS}
) 

link_directories( ${LINK_DIRECTORIES})

set(SRCS
FairMCSplitEventHeader.cxx
)

Set(HEADERS 
FairMCSplitEventHeader.h
)

Set(NO_DICT_SRCS
devices/FairMQPrimaryGeneratorDevice.cxx
devices/FairMQTransportDevice.cxx
devices/FairMQChunkMerger.cxx
)

Set(NO_DICT_HEADERS
devices/FairMQPrimaryGeneratorDevice.h
devices/FairMQTransportDevice.h
devices/FairMQChunkMerger.h
)

Set(LINKDEF SimMQLinkDef.h)
Set(LIBRARY_NAME SimMQ)
Set(DEPENDENCIES
    Base 
    GeoBase
    ParBase
    MCStack
    FairMQ::FairMQ
    BaseMQ 
    Gen
    Passive
    Pixel
    Boost::program_options
)

GENERATE_LIBRARY()

Install(FILES ${NO_DICT_HEADERS} DESTINATION include)
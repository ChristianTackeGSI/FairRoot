/********************************************************************************
 * Copyright (C) 2014-2019 GSI Helmholtzzentrum fuer Schwerionenforschung GmbH  *
 *                                                                              *
 *              This software is distributed under the terms of the             *
 *              GNU Lesser General Public Licence (LGPL) version 3,             *
 *                  copied verbatim in the file "LICENSE"                       *
 ********************************************************************************/

#include "runFairMQDevice.h"

#include "PixelFindHits.h"

// PixelDetector example
#include "FairMQPixelTaskProcessorBin.h"

#include <string>

using HitFinder = FairMQPixelTaskProcessorBin<PixelFindHits>;

namespace bpo = boost::program_options;

void addCustomOptions(bpo::options_description& options)
{
    options.add_options()
        ("task-name",   bpo::value<std::string>()->required()               , "Name of task to run")
        ("keep-data",   bpo::value<std::string>()                           , "Name of data to keep in stream")
        ("in-channel",  bpo::value<std::string>()->default_value("data-in") , "input channel name")
        ("out-channel", bpo::value<std::string>()->default_value("data-out"), "output channel name")
        ("par-channel", bpo::value<std::string>()->default_value("param")   , "param channel name")
        ("static-pars", bpo::value<bool>       ()->default_value(false)     , "static parameters flag");
}

FairMQDevicePtr getDevice(const FairMQProgOptions& config)
{
    std::string taskname = config.GetValue<std::string>("task-name");

    LOG(info) << "get device with setting!";

    if (taskname == "PixelFindHits") {
        return new HitFinder();
    }

    LOG(info) << "TASK \"" << taskname << "\" UNKNOWN!!!";
    return 0;
}

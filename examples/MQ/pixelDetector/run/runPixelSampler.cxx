/********************************************************************************
 * Copyright (C) 2014-2019 GSI Helmholtzzentrum fuer Schwerionenforschung GmbH  *
 *                                                                              *
 *              This software is distributed under the terms of the             *
 *              GNU Lesser General Public Licence (LGPL) version 3,             *
 *                  copied verbatim in the file "LICENSE"                       *
 ********************************************************************************/

#include "runFairMQDevice.h"

#include "PixelDigiSource.h"
#include "PixelDigiBinSource.h"

// PixelDetector example
#include "FairMQPixelSampler.h"

#include <string>
#include <vector>
#include <cstdint>

namespace bpo = boost::program_options;

void addCustomOptions(bpo::options_description& options)
{
    options.add_options()
        ("file-name",    bpo::value<std::vector<std::string>>()                                  , "Path to the input file")
        ("max-index",    bpo::value<int64_t>                 ()->default_value(-1)               , "number of events to read")
        ("branch-name",  bpo::value<std::vector<std::string>>()->required()                      , "branch name")
        ("sampler-type", bpo::value<std::string>             ()->default_value("FairFileSource") , "FairSource type")
        ("out-channel",  bpo::value<std::string>             ()->default_value("data-out")       , "output channel name")
        ("ack-channel",  bpo::value<std::string>             ()->default_value("")               , "ack channel name");
}

FairMQDevicePtr getDevice(const FairMQProgOptions& config)
{
    std::string              samplerType = config.GetValue<std::string>             ("sampler-type");
    std::vector<std::string> filename    = config.GetValue<std::vector<std::string>>("file-name");

    FairMQPixelSampler* sampler = new FairMQPixelSampler();

    if (samplerType == "FairFileSource") {
    } else if (samplerType == "PixelDigiSource") {
        if (!filename.empty()) {
            PixelDigiSource* digiSource = new PixelDigiSource(filename.at(0));
            sampler->SetSource(digiSource);
        }
    } else if (samplerType == "PixelDigiBinSource") {
        if (!filename.empty()) {
            PixelDigiBinSource* digiSource = new PixelDigiBinSource(filename.at(0));
            sampler->SetSource(digiSource);
        }
    } else {
        LOG(error) << "Sampler \"" << samplerType << "\" unknown! Set it to \"FairFileSource\" or \"PixelDigiSource\" or \"PixelDigiBinSource\"";
        return nullptr;
    }

  return sampler;
}

#include "runFairMQDevice.h"

// MQRunSim
#include "FairMQChunkMerger.h"

namespace bpo = boost::program_options;

void addCustomOptions(bpo::options_description& options)
{
    options.add_options()
        ("in-channel",  bpo::value<std::string>()->default_value("data-in") , "input channel name")
        ("out-channel", bpo::value<std::string>()->default_value("data-out"), "output channel name");
}

FairMQDevicePtr getDevice(const FairMQProgOptions& config)
{
    return new FairMQChunkMerger();
}

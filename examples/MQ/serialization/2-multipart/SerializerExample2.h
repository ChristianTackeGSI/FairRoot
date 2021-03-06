#ifndef BASICSERIALIZEREXAMPLE2_H
#define BASICSERIALIZEREXAMPLE2_H

#include <FairMQMessage.h>

namespace boost { namespace serialization { class access; } }

struct Ex2Header
{
    int EventNumber = 0;
    int DetectorId = 0;
};

namespace boost {
namespace serialization {

template<class Archive>
void serialize(Archive& ar, Ex2Header& header, const unsigned int /*version*/)
{
    ar& header.EventNumber;
    ar& header.DetectorId;
}

} // namespace serialization
} // namespace boost

struct SerializerEx2
{
    void Serialize(FairMQMessage& msg, Ex2Header* header)
    {
        msg.Rebuild(header,
                    sizeof(header),
                    [](void* ptr, void* /*hint*/) { delete static_cast<Ex2Header*>(ptr); }
                    );
    }

    void Deserialize(FairMQMessage& msg, Ex2Header*& header)
    {
        header = static_cast<Ex2Header*>(msg.GetData());
    }
};

#endif

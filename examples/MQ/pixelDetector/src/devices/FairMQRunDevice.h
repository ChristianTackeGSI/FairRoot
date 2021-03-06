/********************************************************************************
 *    Copyright (C) 2017 GSI Helmholtzzentrum fuer Schwerionenforschung GmbH    *
 *                                                                              *
 *              This software is distributed under the terms of the             *
 *         GNU Lesser General Public Licence version 3 (LGPL) version 3,        *
 *                  copied verbatim in the file "LICENSE"                       *
 ********************************************************************************/

/**
 * FairMQRunDevice.h
 *
 * @since 2018-02-01
 * @author R. Karabowicz
 */

#ifndef FAIRMQRUNDEVICE_H_
#define FAIRMQRUNDEVICE_H_

#include <string>

#include <FairMQDevice.h>

class TObject;

class FairMQRunDevice : public FairMQDevice
{
  public:
   FairMQRunDevice() {}
   virtual ~FairMQRunDevice() {}

   virtual void SendBranches();

 protected:
   void SendObject(TObject* obj, const std::string& chan);

 private:
   FairMQRunDevice(const FairMQRunDevice&);
   FairMQRunDevice& operator=(const FairMQRunDevice&);
};

#endif /* FAIRMQRUNDEVICE_H_ */

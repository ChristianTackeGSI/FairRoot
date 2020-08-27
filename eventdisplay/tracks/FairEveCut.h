/*
 * FairEveCut.h
 *
 *  Created on: 5 maj 2020
 *      Author: Daniel Wielanek
 *		E-mail: daniel.wielanek@gmail.com
 *		Warsaw University of Technology, Faculty of Physics
 */
#ifndef FAIREVECUT_H_
#define FAIREVECUT_H_

#include <TObject.h>
#include <GuiTypes.h>
#include <Rtypes.h>
#include <RtypesCore.h>
#include <TGedFrame.h>             // for TGedFrame
#include <TGFrame.h>
#include <TGDoubleSlider.h>
#include <TGButton.h>
#include <TGNumberEntry.h>
#include <TGLabel.h>

/**
 * base class for graphics cuts
 */
class FairEveCut : public TObject{
protected:
    const Int_t fWidth;
    const TString fName;
    TGedFrame *fParent;
    TGCompositeFrame *fTab;
public:
    /**
     * default c-tor
     * @param frame paretn frame (editor)
     * @param tab tab in editor
     * @param name name of the cut
     * @param width width of frame
     */
    FairEveCut(TGedFrame *frame=0,TGCompositeFrame *tab=0,TString name="",Int_t width=170);
    virtual void Init()=0;
    void AddUpdateButton();
    virtual ~FairEveCut();
    ClassDef(FairEveCut,0)
};

/**
 * cut for selection of objects with properting from given range
 */
class FairEveMinMaxCut: public FairEveCut{
    TGCheckButton *fUseCut;
    TGNumberEntry *fLow;
    TGNumberEntry *fHigh;
public:
    FairEveMinMaxCut(TGedFrame *frame=0,TGCompositeFrame *tab=0,TString name="",Int_t width=170);
    void Init();
    Bool_t GetValues(Double_t &min, Double_t &max)const;
    virtual ~FairEveMinMaxCut();
    ClassDef(FairEveMinMaxCut,0)
};

/**
 * represents booealn cut, check button is used to accept objects
 */
class FairEveBoolCut: public FairEveCut{
    TGCheckButton *fHasCut;
    Bool_t fStatus;
    Bool_t fAutoUpdate;
public :
    FairEveBoolCut(TGedFrame *frame=0,TGCompositeFrame *tab=0,TString name="",Int_t width=170);
    void Init();
    void UpdateWhenChanged(){fAutoUpdate = kTRUE;};
    void SetInitStatus(Bool_t stat){fStatus = stat;};
    Bool_t GetValue()const{return fHasCut->IsOn();};
    virtual ~FairEveBoolCut();
    ClassDef(FairEveBoolCut,0)
};

/**
 * cut for selection of particles with given property expressed as an integer nubmer
 */
class FairEveIntCut: public FairEveCut{
    TGCheckButton *fUseCut;
    TGNumberEntry *fCut;
public:
    FairEveIntCut(TGedFrame *frame=0,TGCompositeFrame *tab=0,TString name="",Int_t width=170);
    void Init();
    Bool_t GetValue(Int_t &val)const;
    virtual ~FairEveIntCut(){};
    ClassDef(FairEveIntCut,0)
};



#endif /* FAIREDTABEDITOR_H_ */

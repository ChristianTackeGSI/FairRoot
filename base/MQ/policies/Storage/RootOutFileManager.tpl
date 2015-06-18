/* 
 * File:   RootOutFileManager.tpl
 * Author: winckler
 *
 * Created on October 7, 2014, 9:41 PM
 */

template <typename DataType>
RootOutFileManager<DataType>::RootOutFileManager() :
    fFileName(),
    fTreeName(),
    fBranchName(),
    fClassName(),
    fFileOption(),
    fUseClonesArray(false),
    fFlowMode(true),
    fWrite(false),
    fOutFile(nullptr),
    fTree(nullptr),
    fOutput(nullptr), 
    fOutputData(nullptr)
{
}


template <typename DataType>
RootOutFileManager<DataType>::RootOutFileManager(const std::string &filename, const std::string &treename, const std::string &branchname, const std::string &Classname, const std::string &FileOption) :
    fFileName(filename),
    fTreeName(treename),
    fBranchName(branchname),
    fClassName(Classname),
    fFileOption(FileOption),
    fUseClonesArray(false),
    fFlowMode(true),
    fWrite(false),
    fOutFile(nullptr),
    fTree(nullptr),
    fOutput(nullptr), 
    fOutputData(nullptr)
{
}


template <typename DataType>
RootOutFileManager<DataType>::~RootOutFileManager() 
{
    if(fFlowMode && fWrite)
        fTree->Write("", TObject::kOverwrite);
    if(fOutFile)
    {
        if(fOutFile->IsOpen())
            fOutFile->Close();
        delete fOutFile;
    }
}

template <typename DataType>
void RootOutFileManager<DataType>::SetFileProperties(const std::string &filename, const std::string &treename, const std::string &branchname, const std::string &ClassName, const std::string &FileOption, bool UseClonesArray, bool flowmode)
{
    fFileName=filename;
    fTreeName=treename;
    fBranchName=branchname;
    fClassName=ClassName;
    fFileOption=FileOption;
    fUseClonesArray=UseClonesArray;
    fFlowMode=flowmode;
    if (!std::is_base_of<TObject, DataType>::value && fUseClonesArray)
    {
        fUseClonesArray=false;
        MQLOG(WARN)<<"Deactivate TClonesArray method : the data class must inherit from TObject.";
    } 
}


template <typename DataType>
void RootOutFileManager<DataType>::SetRootFileProperties(const std::string &filename, const std::string &treename, const std::string &branchname, const std::string &ClassName, const std::string &FileOption, bool UseClonesArray, bool flowmode)
{
    SetFileProperties(filename, treename, branchname, ClassName, FileOption, UseClonesArray, flowmode);
}


//______________________________________________________________________________
template <typename DataType>
void RootOutFileManager<DataType>::ReadDir(TDirectory *dir)
{
    TDirectory *dirsav = gDirectory;
    TIter next(dir->GetListOfKeys());
    TKey *key;
    while ((key = (TKey*)next()))
    {
        if (key->IsFolder())
        {
            dir->cd(key->GetName());
            TDirectory *subdir = gDirectory;
            ReadDir(subdir);
            dirsav->cd();
            continue;
        }
        else
            SeekObject(key);
    }
}



//______________________________________________________________________________
template <typename DataType>
void RootOutFileManager<DataType>::SeekObject(TKey *key)
{
    /*TObject* obj ;
    obj = key->ReadObj();
    if ((strcmp(obj->IsA()->GetName(),"TProfile")!=0)
    && (!obj->InheritsFrom("TH2"))
    && (!obj->InheritsFrom("TH1"))
    && (!obj->InheritsFrom("Header"))
    )
    {
        printf("[Warning] Object %s is not a header nor 1D nor 2D histogram : "
        "will not be converted\n",obj->GetName());
    }
    printf("[INFO] Found object with name:%s and title:%s\n", obj->GetName(), obj->GetTitle());
    /// SEARCH FOR TH1D
    if(obj->InheritsFrom("TH1D"))
    {
        TH1D* histo1D=NULL;
        histo1D=(TH1D*)gDirectory->Get(obj->GetName());
        if(histo1D)
        {
            f1DHisto.push_back(new TH1D(*histo1D));
            AddToListTree(f1DHisto[fHisto1DCounter]);
            fHisto1DCounter++;
        }
    }*/
    
}




template <typename DataType>
std::vector<std::vector<DataType> > RootOutFileManager<DataType>::GetAllObj(const std::string &filename, const std::string &treename, const std::string &branchname)
{
    fWrite=false;
    TFile* file=TFile::Open(filename.c_str(),"READ");
    std::vector<std::vector<DataType> > Allobj;
    std::vector<DataType> TempObj;
    if(file)
    {
        fTree=(TTree*)file->Get(fTreeName.c_str());
    }
    else
        MQLOG(ERROR)<<"Could not open file"<<fTreeName.c_str();
        
    if(fTree)
    {
        if(fUseClonesArray)
        {
            fOutput = new TClonesArray(fClassName.c_str());
            fTree->SetBranchAddress(fBranchName.c_str(), &fOutput);
            
            
            for (Long64_t i = 0; i < fTree->GetEntries(); i++)
            {
                
                TempObj.clear();
                fTree->GetEntry(i);
                for (Int_t iobj = 0; iobj < fOutput->GetEntriesFast(); ++iobj)
                {
                    DataType* Data_i = reinterpret_cast<DataType*>(fOutput->At(iobj));
                    if (!Data_i)
                        continue;
                    TempObj.push_back(*Data_i);
                }
                Allobj.push_back(TempObj);
            }
        }
        else
        {
            fTree->SetBranchAddress(branchname.c_str(),&fOutputData);
            for (Long64_t i = 0; i < fTree->GetEntries(); i++)
            {
                fTree->GetEntry(i);
                DataType Data_i=*fOutputData;
                TempObj.push_back(Data_i);
            }
            Allobj.push_back(TempObj);
        }
    }
    else
        MQLOG(ERROR)<<"Could not find tree "<<treename.c_str();
    
    
    
    
    if (file) file->Close();
    return Allobj;
}

template <typename DataType>
void RootOutFileManager<DataType>::AddToFile(std::vector<DataType>& InputData) 
{
    if(fUseClonesArray)
    {
        fOutput->Delete();

        for (unsigned int i(0); i < InputData.size(); ++i)
        {
            new ((*fOutput)[i]) DataType(InputData.at(i));
        }

        if (fOutput->IsEmpty())
        {
            MQLOG(ERROR) << "RootOutFileManager::AddToFile(vector<DataType>&): No Output array!";
        }

        fTree->Fill();
    }
    else
    {
        for (unsigned int i(0); i < InputData.size(); ++i)
        {
            fOutputData=&InputData.at(i);
            fTree->Fill();
        }
    }
    if(!fFlowMode)
        fTree->Write("", TObject::kOverwrite);
}

template <typename DataType>
void RootOutFileManager<DataType>::AddToFile(TClonesArray* InputData) 
{
    if(fUseClonesArray)
    {
        
        fOutput=InputData;
        fTree->SetBranchAddress(fBranchName.c_str(), &fOutput);
        
        if (fOutput->IsEmpty())
        {
            MQLOG(ERROR) << "RootOutFileManager::AddToFile(TClonesArray*): No Output array!";
        }
        fTree->Fill();
        if(!fFlowMode)
            fTree->Write("", TObject::kOverwrite);
    }
    else
    {
        MQLOG(ERROR) << "RootOutFileManager::AddToFile(TClonesArray*): TClonesArray not set as output container";
    }
    
}

template <typename DataType>
void RootOutFileManager<DataType>::AddToFile(DataType* ObjArr, long size)
{
    //todo : check if fine when update option
    if(fUseClonesArray)
    {
        fOutput->Delete();

        for (unsigned int i(0); i < size; ++i)
        {
            new ((*fOutput)[i]) DataType(ObjArr[i]);
        }

        if (fOutput->IsEmpty())
        {
            MQLOG(ERROR) << "RootOutFileManager::AddToFile(vector<DataType>&): No Output array!";
        }

        fTree->Fill();
        if(!fFlowMode)
            fTree->Write("", TObject::kOverwrite);
    }
    else
    {
        std::vector<DataType>  DataVector(ObjArr, ObjArr +size);
        AddToFile(DataVector);
    }
}


template <typename DataType>
void RootOutFileManager<DataType>::AddToFile(FairMQMessage* msg)
{
    int inputSize = msg->GetSize();
    int NumInput=0;
    if(inputSize>0)
        NumInput = inputSize / sizeof(DataType);
    fOutputData = static_cast<DataType*>(msg->GetData());
    AddToFile(fOutputData,NumInput);
}


template <typename DataType>
void RootOutFileManager<DataType>::InitOutputFile()
{
    fWrite=true;
    fOutFile = TFile::Open(fFileName.c_str(),fFileOption.c_str());
    
    bool updateTree=false;
    
    // if given option is update attempt to get tree from file
    if(fFileOption=="UPDATE")
    {
        fTree=(TTree*)fOutFile->Get(fTreeName.c_str());
        if(fTree) 
        {
            updateTree=true;
            MQLOG(INFO) <<"Update tree";
        }
        else
        {
            updateTree=false;
            MQLOG(INFO) <<"Create new tree";
        }
    }
    
    // if tree not found or option is not UPDATE, create a new tree
    if(!updateTree)
        fTree = new TTree(fTreeName.c_str(), "Test output");
    
    
    // direct storage or TClonesArray
    if(fUseClonesArray)
    {
        fOutput = new TClonesArray(fClassName.c_str());
        if(updateTree)
            fTree->SetBranchAddress(fBranchName.c_str(), &fOutput);
        else
            fTree->Branch(fBranchName.c_str(),"TClonesArray", &fOutput);
    }
    else
    {
        if(updateTree)
            fTree->SetBranchAddress(fBranchName.c_str(), &fOutputData);
        else
            fTree->Branch(fBranchName.c_str(),fClassName.c_str(), &fOutputData);
    }
}


template <typename DataType>
void RootOutFileManager<DataType>::Init()
{
    fWrite=true;
    fOutFile = TFile::Open(fFileName.c_str(),fFileOption.c_str());
    
    bool updateTree=false;
    
    // if given option is update attempt to get tree from file
    if(fFileOption=="UPDATE")
    {
        fTree=(TTree*)fOutFile->Get(fTreeName.c_str());
        if(fTree) 
        {
            updateTree=true;
            MQLOG(INFO) <<"Update tree";
        }
        else
        {
            updateTree=false;
            MQLOG(INFO) <<"Create new tree";
        }
    }
    
    // if tree not found or option is not UPDATE, create a new tree
    if(!updateTree)
        fTree = new TTree(fTreeName.c_str(), "Test output");
    
    
    // direct storage or TClonesArray
    if(fUseClonesArray)
    {
        fOutput = new TClonesArray(fClassName.c_str());
        if(updateTree)
            fTree->SetBranchAddress(fBranchName.c_str(), &fOutput);
        else
            fTree->Branch(fBranchName.c_str(),"TClonesArray", &fOutput);
    }
    else
    {
        if(updateTree)
            fTree->SetBranchAddress(fBranchName.c_str(), &fOutputData);
        else
            fTree->Branch(fBranchName.c_str(),fClassName.c_str(), &fOutputData);
    }
}


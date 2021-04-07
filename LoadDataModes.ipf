#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave acces

Function Loadoption(String mode)

    Variable i,refNum,numFilesSelected,numFilePos
	String message = "Select one or more files"
	String outputPaths,path,DirectoryPath,Directoryname,FilenameWithExtend,Filename
    String fileFilters = "Data Files (*.txt,*.dat,*.csv):.txt,.dat,.csv;"
	fileFilters += "XRD Files:.itx,.int;"
    fileFilters += "Image Files:.JPG;"
	fileFilters += "All Files:.*;"


    SetDataFolder root:
    //___open dialog and choose files
	Open/D/R/MULT=1/F=fileFilters /M=message refNum
	outputPaths = S_fileName
	
	if (strlen(outputPaths) == 0)
		Print "Cancelled"
        return 0
	else
		numFilesSelected = ItemsInList(outputPaths, "\r")
        Make/T/O/N=(numFilesSelected) LoadFiles_wave
		for(i=0; i<numFilesSelected; i+=1)
            path = StringFromList(i, outputPaths, "\r")
            numFilePos = ItemsInList(path,":")
            FilenameWithExtend = StringFromList(numFilePos-1, path, ":")
            LoadFiles_wave[i] = FilenameWithExtend
		endfor
    endif

    //____load files
    NewPath DirectoryPath  ReplaceString(":"+StringFromList(numFilePos-1, path, ":"),StringFromList(numFilesSelected-1, outputPaths, "\r"),"")
    Directoryname = StringFromList(numFilePos-2, path, ":")
	Directoryname = StringConvert(Directoryname)
    NewDataFolder/O/S root:$Directoryname

    Loadoption_Switch(mode,numFilesSelected)
End

Function Loadoption_Switch(string mode,Variable numFilesSelected)
    Variable i
    String funcname
    Wave w = root:Loadoption_List
    for(i=0;i<DimSize(w,0);i++)
        if(stringmatch(mode,"Default")==1)
            Loadoption_Default(numFilesSelected)
            break
        elseif(stringmatch(mode,num2str(i))==1)
            funcname = "Loadoption_"+num2str(i)
            FUNCREF Loadoption_0 Loadoption_num=$funcname
            Loadoption_num(numFilesSelected)
            break
        endif
    endfor
end

// default
Function Loadoption_Default(Variable numFilesSelected)
    Variable i
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        // LoadWave/A/G/D/W/P=DirectoryPath w[i]
        LoadWave/A/J/D/W/P=DirectoryPath/K=0/L={0,1,0,0,0} w[i]
        w[i] = Filename

        // Wave dummy1 = $("Time___sec___I_T_graph"), dummy2 = $("Cuurent___A___I_T_graph")
        Wave dummy1 = $("wave0"), dummy2 = $("wave1")

        Duplicate/O dummy1 $(w[i]+"_xwave")
        Duplicate/O dummy2 $(w[i]+"_ywave")
        killwaves dummy1,dummy2//,dummy3,dummy4
        // killwaves dummy1,dummy2,dummy3,dummy4
    endfor
End

// FT-IR
Function Loadoption_0(Variable numFilesSelected)
    Variable i
    String Filename
    
    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,0,0,0,0} w[i]
        w[i] = Filename

        Wave dummy1 = $("wave0"), dummy2 = $("wave1")
        dummy2 = dummy2*-1
        Duplicate/O dummy1 $(w[i]+"_xwave")
        Duplicate/O dummy2 $(w[i]+"_ywave")
        killwaves dummy1,dummy2
    endfor
End

// UV-Vis
Function Loadoption_1(Variable numFilesSelected)
    Variable i
    String Filename,DataFoldername
    DataFoldername = getdatafolder(0)
    DataFoldername = ReplaceString("'",DataFoldername,"")

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,3,0,0,0} w[i]
        w[i] = Filename

        if(V_flag == 2)
            Wave dummy1 = $("wave0"), dummy2 = $("wave1")
            Duplicate/O dummy1 $(w[i]+"_xwave")
            Duplicate/O dummy2 $(w[i]+"_ywave")

            killwaves dummy1,dummy2
        else
            Wave dummy1 = $("wave0"), dummy2 = $("wave1"), dummy3 = $("wave2"), dummy4 = $("wave3")
            Duplicate/O dummy2 $(w[i]+"_xwave")
            Duplicate/O dummy3 $(w[i]+"_ywave")
            killwaves dummy1,dummy2,dummy3,dummy4
        endif
    endfor
End

// XRD
Function Loadoption_2(Variable numFilesSelected)
    Variable i
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,2,0,0,0} w[i]
        w[i] = Filename

        Wave dummy1 = $("wave0"), dummy2 = $("wave1"), dummy3 = $("wave2"), dummy4 = $("wave3"), dummy5 = $("wave4")
        dummy2 = dummy2-dummy4
        dummy3 = dummy3-dummy4
        Duplicate/O dummy1 $(w[i]+"_theta")
        Duplicate/O dummy2 $(w[i]+"_ywave")
        Duplicate/O dummy3 $(w[i]+"_ycal")
        Duplicate/O dummy4 $(w[i]+"_bkg")
        Duplicate/O dummy5 $(w[i]+"_diff")
        killwaves dummy1,dummy2,dummy3,dummy4,dummy5
    endfor
End

// UPS
Function Loadoption_3(Variable numFilesSelected)
    Variable i,Reigion
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = RemoveListItem(ItemsInList(w[i],".")-1,w[i],".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,0,0,0,0} w[i]
        w[i] = Filename

        Reigion = stringmatch(Filename,"*cutoff*")
        if(Reigion == 1)
            DataCorrection_UPS("Cutoff")
            Wave dummy1 = $("X_Data"),dummy2 = $("X1_"),dummy3 = $("x_fermi")
            Duplicate/O dummy2 $(w[i]+"_ywave")
            Duplicate/O dummy3 $(w[i]+"_xwave")
			killwaves dummy1,dummy2,dummy3
        else
            Reigion = stringmatch(Filename,"*VB*")
            if(Reigion == 1)
                DataCorrection_UPS("Valence")
                Wave dummy1 = $("X_Data"),dummy2 = $("X1_"),dummy3 = $("x_fermi"),dummy4 = $("I_cor")
                Duplicate/O dummy4 $(w[i]+"_ywave")
                Duplicate/O dummy3 $(w[i]+"_xwave")
                killwaves dummy1,dummy2,dummy3,dummy4
            else
                //___Caution
                dowindow/K Caution_panel
                dowindow/F Caution_panel
                NewPanel/K=1/FLT=1/N=Caution_panel/W=(100,200,700,300)
                Titlebox Caution title="Caution! pleaze insert 'VB' or 'cutoff' in the data-files name."
                Titlebox Caution pos={28,28},fSize=18,frame=0 
                return 0
            endif
        endif
    endfor
End

Function DataCorrection_UPS(string Reigion)
	variable E_fermi=17.25,E_beta=1.8,E_gamma=2.52,C_beta=0.018,C_gamma=0.005    //He
	// variable E_fermi=4.42,E_beta=1.14,E_gamma=1.48,C_beta=0.18,C_gamma=0.802  //Xe
	Wave x_raw = $("X_Data");Wave I_raw = $("X1_")

	strswitch(Reigion)
		case "Valence":
			//___import data
			variable dim=DimSize(x_raw,0),E_step=(x_raw[1]-x_raw[0])
			make/O/N=(dim) x_fermi
			x_fermi = E_fermi-x_raw

			variable y_beta,y_gamma
			y_beta = E_fermi-x_raw[0]-2*E_beta
			y_gamma = E_fermi-x_raw[0]-2*E_beta-E_gamma

			//___correction
			variable i=0,m=0,n=0
			make/O/N=(dim) I_cor
			do
				if(x_fermi[i] < y_beta)
					I_cor[i] = I_raw[i]
				elseif(y_beta <= x_fermi[i] && x_fermi[i] < y_gamma)
					variable p_beta
					p_beta = ceil(y_beta/E_step)
					I_cor[i] = I_raw[i]-I_raw[p_beta+m]*C_beta
					m+=1
				else
					variable p_gamma
					p_gamma = ceil(y_gamma/E_step)
					I_cor[i] = I_raw[i]-I_raw[p_gamma+n]*C_beta-I_raw[p_gamma+n]*C_gamma
					n+=1	
				endif
				i+=1
			while(i<=dim-1)
			break
		case "Cutoff":
			//___correction
			variable dim1=DimSize(x_raw,0)
			make/O/N=(dim1) x_fermi
			x_fermi = E_fermi-x_raw+5
			break
	endswitch
end

// IPES
Function Loadoption_4(Variable numFilesSelected)
    Variable i,E_fermi = 7.3
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,0,0,0,0} w[i]
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,1,1,0,0}/F={2,12,0} w[i]
        w[i] = Filename

        Wave dummy1 = $("X_Empty_"), dummy2 = $("wave0"), dummy3 = $("wave1")
        make/O/N=(DimSize(dummy1,0)) $(w[i]+"_IPES_xwave")
        Wave dummy4 = $(w[i]+"_IPES_xwave")
        Setscale/I x,dummy2[0],dummy3[0],dummy4
        dummy4 = x
        dummy4 = E_fermi-dummy4
        
        Duplicate/O dummy1 $(w[i]+"_IPES_ywave")
        Duplicate/O dummy1 $(w[i]+"_IPES_smt")
        Smooth/EVEN/B 40,$(w[i]+"_IPES_smt")
        
        killwaves dummy1,dummy2,dummy3
    endfor
End

// calc FT-IR
Function Loadoption_6(Variable numFilesSelected)
    Variable i
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,0,0,0,0} w[i]
        w[i] = Filename

        Wave dummy1 = $("wave0"), dummy2 = $("wave1"), dummy3 = $("wave2"), dummy4 = $("wave3"), dummy5 = $("wave4")
        Wave dummy6 = $("wave5"), dummy7 = $("wave6"), dummy8 = $("wave7"), dummy9 = $("wave8"), dummy10 = $("wave9")
        Wave dummy11 = $("wave10"), dummy12 = $("wave11")

        wavestats/Q dummy12
        dummy12 = dummy12/V_max
        Duplicate/O dummy11 $(w[i]+"_xwave")
        Duplicate/O dummy12 $(w[i]+"_ywave")
        killwaves dummy1,dummy2,dummy3,dummy4,dummy5,dummy6,dummy7,dummy8,dummy9,dummy10,dummy11,dummy12
    endfor
End

// calc UV-Vis
Function Loadoption_7(Variable numFilesSelected)
    Variable i
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,0,0,0,0} w[i]
        w[i] = Filename

        Wave dummy1 = $("wave0"), dummy2 = $("wave1"), dummy3 = $("wave2"), dummy4 = $("wave3"), dummy5 = $("wave4")
        Wave dummy6 = $("wave5"), dummy7 = $("wave6"), dummy8 = $("wave7"), dummy9 = $("wave8"), dummy10 = $("wave9")
        Wave dummy11 = $("wave10"), dummy12 = $("wave11"), dummy13 = $("wave12"), dummy14 = $("wave13"), dummy15 = $("wave14")
        Wave dummy16 = $("wave15"), dummy17 = $("wave16"), dummy18 = $("wave17")

        Duplicate/O dummy15 $(w[i]+"_xwave")
        Duplicate/O dummy16 $(w[i]+"_ywave")
        killwaves dummy1,dummy2,dummy3,dummy4,dummy5,dummy6,dummy7,dummy8,dummy9,dummy10,dummy11,dummy12,dummy13,dummy14,dummy15,dummy16,dummy17,dummy18
    endfor
End

// calc XRD
Function Loadoption_8(Variable numFilesSelected)
    Variable i
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,0,0,0,0} w[i]
        w[i] = Filename

        // Wave dummy1 = $("wave0"), dummy2 = $("wave1"), dummy3 = $("wave2")
        Wave dummy1 = $("wave0"), dummy2 = $("wave1"), dummy3 = $("wave2"), dummy4 = $("wave3")
        Duplicate/O dummy1 $(w[i]+"_theta")
        Duplicate/O dummy2 $(w[i]+"_ywave")
        Duplicate/O dummy2 $(w[i]+"_ycal")
        killwaves dummy1,dummy2,dummy3,dummy4
    endfor
End

// calc voigt convolution
Function Loadoption_10(Variable numFilesSelected)
    Variable i,j
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,0,0,0,0} w[i]
        w[i] = Filename
        print "debyg"

        Wave dummy0 = $("wave0")
        Duplicate/O dummy0 $(w[i]+"_ywave")
        killwaves dummy0
    endfor
    
End

// kinetic
Function Loadoption_13(Variable numFilesSelected)
    NVAR Peak1 = root:Kinetic_Peak1,Peak2 = root:Kinetic_Peak2

    Variable i,j,d_size
    String Filename,DataFoldername
    DataFoldername = getdatafolder(0)
    DataFoldername = ReplaceString("'",DataFoldername,"")
    make/O/N=(numFilesSelected) $(DataFoldername+"_Peak1_ywave")
    make/O/N=(numFilesSelected) $(DataFoldername+"_Peak1_xwave")
    Wave w_Peak1y = $(DataFoldername+"_Peak1_ywave"), w_Peak1x = $(DataFoldername+"_Peak1_xwave")

    make/O/N=(numFilesSelected) $(DataFoldername+"_Peak2_ywave")
    make/O/N=(numFilesSelected) $(DataFoldername+"_Peak2_xwave")
    Wave w_Peak2y = $(DataFoldername+"_Peak2_ywave"), w_Peak2x = $(DataFoldername+"_Peak2_xwave")

    make/O/N=(numFilesSelected) $(DataFoldername+"_ColorIndex_ywave")
    make/O/N=(numFilesSelected) $(DataFoldername+"_ColorIndex_xwave")
    Wave w_CIy = $(DataFoldername+"_ColorIndex_ywave"), w_CIx = $(DataFoldername+"_ColorIndex_xwave")

    make/O/N=(numFilesSelected) $(DataFoldername+"_R0_R1_ywave")
    make/O/N=(numFilesSelected) $(DataFoldername+"_R0_R1_xwave")
    Wave w_R0R1y = $(DataFoldername+"_R0_R1_ywave"), w_R0R1x = $(DataFoldername+"_R0_R1_xwave")

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/G/D/W/P=DirectoryPath/L={0,3,0,0,0}/Q w[i]
        w[i] = Filename

        if(V_flag == 2)
            Wave dummy1 = $("wave0"), dummy2 = $("wave1")
            Duplicate/O dummy1 $(w[i]+"_xwave")
            Duplicate/O dummy2 $(w[i]+"_ywave")

            //for time resolution
            d_size = Dimsize(dummy2,0)
            Setscale x,0,numFilesSelected,w_Peak1x
            Setscale x,0,numFilesSelected,w_Peak2x
            Setscale x,0,numFilesSelected,w_CIx
            Setscale x,0,numFilesSelected,w_R0R1x
            w_Peak1x = 5*x
            w_Peak2x = 5*x
            w_CIx = 5*x
            w_R0R1x = 5*x
            for(j=0;j<d_size;j++)
                if(ceil(dummy1[j]) == Peak1)
                    w_Peak1y[i] = dummy2[j]
                endif

                if(ceil(dummy1[j]) == Peak2)
                    w_Peak2y[i] = dummy2[j]
                endif
            endfor
            w_CIy = w_Peak1y/w_Peak2y
            // w_R0R1y[i] = w_Peak2y[i]/w_Peak2y[0]
            w_R0R1y[i] = Peak2/w_Peak2y[i]
            print Peak2
            killwaves dummy1,dummy2
        else
            Wave dummy1 = $("wave0"), dummy2 = $("wave1"), dummy3 = $("wave2"), dummy4 = $("wave3")
            Duplicate/O dummy2 $(w[i]+"_xwave")
            Duplicate/O dummy3 $(w[i]+"_ywave")

            //for time resolution
            d_size = Dimsize(dummy2,0)
            // Setscale x,0,numFilesSelected,w_Peak1x
            // Setscale x,0,numFilesSelected,w_Peak2x
            // Setscale x,0,numFilesSelected,w_CIx
            // Setscale x,0,numFilesSelected,w_R0R1x
            w_Peak1x = 5*x
            w_Peak2x = 5*x
            w_CIx = 5*x
            w_R0R1x = 5*x
            for(j=0;j<d_size;j++)
                if(ceil(dummy1[j]) == Peak1)
                    w_Peak1y[i] = dummy2[j]
                endif

                if(ceil(dummy1[j]) == Peak2)
                    w_Peak2y[i] = dummy2[j]
                endif
            endfor
            w_CIy = w_Peak1y/w_Peak2y
            w_R0R1y[i] = w_Peak2y[i]/w_Peak2y[0]
            killwaves dummy1,dummy2,dummy3,dummy4
        endif
    endfor
End

// AFM
Function Loadoption_12(Variable numFilesSelected)
    Variable i,img_dim,j,k,c
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/J/D/K=0/V={";"," $",0,0}/P=DirectoryPath w[i]

        w[i] = Filename
        Wave dummy1 = $("wave0"), dummy2 = $("wave1"), dummy3 = $("wave2")
        //___convert to um
        dummy1 = dummy1*10^6 
        dummy3 = dummy3*10^6
        
        //___make xwave
        Findpeak/P  dummy1
        img_dim = ceil(V_PeakLoc)
        make/O/N=(img_dim,img_dim) $(w[i]+"_img")
        wave w_img =  $(w[i]+"_img")
        
        //___make AFM image
        for(j=0;j<img_dim;j++)
            c=(k+1)*j
            for(k=0;k<img_dim;k++)
                w_img[k][j] = dummy3[k+c]
            endfor
        endfor

        //____make histgram
        wavestats/Q w_img
		make/N=(img_dim)/O $(w[i]+"_hist_ywave")
        wave w_hist_y =  $(w[i]+"_hist_ywave")
		Histogram/C/B=1 w_img,w_hist_y
    
        make/O/N=(Dimsize(w_hist_y,0)) $(w[i]+"_hist_xwave")
        wave w_hist_x = $(w[i]+"_hist_xwave")
        wavestats/Q w_img
        Setscale x,V_min,V_max,w_hist_x
        w_hist_x = x
        Duplicate/O/R=(0,img_dim) dummy1 $(w[i]+"_xwave")
        Duplicate/O/R=(0,img_dim) dummy1 $(w[i]+"_ywave")

        killwaves dummy1,dummy2,dummy3        
        // ImageLoad/T=jpeg/P=DirectoryPath/Q w[i]

        // Duplicate/O/R=(533,1509)(263,1228) $w[i] $(num2str(i)+"_ywave")
        // // Duplicate/O $w[i] $(num2str(i)+"_ywave")

        // killwaves $w[i]
    endfor
End

// exp_6
Function Loadoption_21(Variable numFilesSelected)
    Variable i,m,k,dim_kpoint,counter_kpoint
    String Filename

    Wave/T w = root:LoadFiles_wave
    for(k=0;k<numFilesSelected;k++)
        Filename = StringFromList(0,w[k], ".")
		Filename = StringConvert(Filename)

        LoadWave/A/J/D/W/P=DirectoryPath/K=0/L={0,0,0,0,0} w[k]
        w[k] = Filename

        Wave dummy1 = $("wave0"), dummy2 = $("wave1")

        make/O/N=(1,1) wave_x,wave_y
        for(i=0;i<DimSize(dummy1,0);i++)
            if(dummy1[i] == 1)
                dim_kpoint = i
                break
            endif
        endfor
        Redimension/N=(dim_kpoint+1) wave_x,wave_y

        for(i=0;i<DimSize(dummy1,0);i++)
            if(i <= dim_kpoint)
                wave_x[i] = dummy1[i]
            endif

            if(dummy1[i] == 1)
                counter_kpoint = dim_kpoint
                for(m=i;m>=(i-dim_kpoint);m--)
                    wave_y[counter_kpoint][0] = dummy2[m]
                    counter_kpoint = counter_kpoint - 1
                endfor
                InsertPoints/M=1 0,1,wave_y
            endif
        endfor
        DeletePoints/M=1 0,1,wave_y

        make/O/T/N=(DimSize(wave_x,0)) $(w[k]+"_xwave_text")
        Duplicate/O wave_x $(w[k]+"_xwave")
        Duplicate/O wave_y $(w[k]+"_ywave")
        killwaves dummy1,dummy2,wave_x,wave_y
    endfor
End

// exp_7
Function Loadoption_22(Variable numFilesSelected)
    Variable i
    String Filename

    Wave/T w = root:LoadFiles_wave
    i=0
    for(i=0;i<numFilesSelected;i++)
        Filename = StringFromList(0,w[i], ".")
		Filename = StringConvert(Filename)
        LoadWave/A/J/D/W/P=DirectoryPath/K=0/L={0,1,0,0,0} w[i]
        w[i] = Filename

        Wave dummy1 = $("TimeW"), dummy2 = $("Elapsed"), dummy3=$("DateW"), dummy4=$("Chan_1_575_0")

        //___remove outlier
        make/O/N=4 W_coef,W_sigma
        CurveFit exp_XOffset dummy4 /X=dummy2
        if(W_sigma[1] > 1e2)
            wave w_dif = $(w[i]+"_dif_ywave")
            Differentiate dummy4 /X=dummy2 /D=w_dif
            w_dif = abs(w_dif)
            wavestats/Q w_dif
            Findpeak/M=(0.9*V_max) w_dif
            DeletePoints 0,V_PeakLoc+1,dummy4
            DeletePoints 0,V_PeakLoc+1,dummy2
            dummy2 = dummy2 - dummy2[0]
        endif
        wavestats/Q dummy4
        dummy4 = dummy4 / V_max //convert Rt -> Rt/R0
        CurveFit exp_XOffset dummy4 /X=dummy2
        dummy4 = dummy4 - W_coef[0]
        dummy4 = dummy4*W_coef[1]/Abs(W_coef[1])
        dummy4 = ln(dummy4)*W_coef[1]/Abs(W_coef[1])
        wavestats/Q dummy4
        dummy4 = dummy4 + abs(V_min)

        //___linefit
        make/O/N=(numFilesSelected) Fit_constant
        make/O/N=10000 $(w[i]+"_fit_ywave")
        wave w_FitCon = $("Fit_Constant"),w_Fit = $(w[i]+"_fit_ywave")
        Curvefit line dummy4 /X=dummy2
        Wavestats/Q dummy4
        w_FitCon[i] = W_coef[1]*(1/V_max)
        Wavestats/Q dummy2
        Setscale/P x,V_min,V_max,w_Fit
        w_Fit = W_coef[1]*x + W_coef[0]

        Duplicate/O dummy2 $(w[i]+"_xwave")
        Duplicate/O dummy2 $(w[i]+"_fit_xwave")
        Duplicate/O dummy4 $(w[i]+"_ywave")
        killwaves dummy1,dummy2,dummy3,dummy4
        // killwaves dummy1,dummy2,dummy3,dummy4
    endfor
End

// CELIV
// Function Loadoption_19(Variable numFilesSelected)
//     Variable i
//     String Filename

//     Wave/T w = root:LoadFiles_wave
//     i=0
//     for(i=0;i<numFilesSelected;i++)
//         Filename = StringFromList(0,w[i], ".")
// 		Filename = StringConvert(Filename)
//         LoadWave/A/G/D/W/P=DirectoryPath/L={0,13,0,0,0} w[i]
//         w[i] = Filename

//         Wave dummy1 = $("wave0"), dummy2 = $("wave1"), dummy3 = $("wave2")

//         Duplicate/O dummy1 $(w[i]+"_xwave")
//         Duplicate/O dummy2 $(w[i]+"_ch1_ywave")
//         Duplicate/O dummy3 $(w[i]+"_ch2_ywave")
//         killwaves dummy1,dummy2,dummy3
//     endfor
// End

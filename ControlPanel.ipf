#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave acces
#include "LoadDataModes"
#include "DisplayModes"
//#include "celivpanel"
// #include "GIFPanel"
// #include "KineticPanel"
// 20200406 ver1.00 relreased.
// 20200408 ver1.01 revision "normalize" checkbox and implement "offset" and "Tile Verticaly".
// 20200410 ver1.02 implement displaying legends. Also append StringConvert for exclude unvalable string in Igor.
// 20200414 ver1.03 implement ColorGenerator.
// 20200512 ver1.04 implement "option" tab. Avalable experiment is "FT-IR;UV-vis;XRD;UPS;IPES", and EXP_* is setupped as default.
// 20200624 ver1.05 modify display option of "FT-IR" and loadoption of "UPS". Former is solved appending SetAxis/A/R and the other is solved appending RemoveListItem.

menu "Control Panel"
	"Control Panel",ControlPanel()
end

Function ControlPanel() : Panel
    SetDataFolder root:
	variable/G Counter=0
	Variable i,columncount

	Make/N=10000/O/T Folder_List=""
    Make/N=10000/O Folder_sel=0
    Make/N=10000/O/T Display_List=""
    Make/N=10000/O Display_sel=0
	Make/N=10000/O/T Display_dir
	make/O/T/N=1 FolderList_title={"Foldername"}
	make/O/T/N=1 DisplayList_title={"Display"}

	Make/N=24/T/O checktitlewave
	checktitlewave[0] = "FT-IR "; checktitlewave[6] = "cal. (FT-IR) "; checktitlewave[12] = "AFM "; checktitlewave[18] = "FET "
	checktitlewave[1] = "UV-Vis "; checktitlewave[7] = "cal. (UV-vis) "; checktitlewave[13] = "Kinetic "; checktitlewave[19] = "CELIV "
	checktitlewave[2] = "XRD "; checktitlewave[8] = "cal. (XRD) "; checktitlewave[14] = "Image for GIF ";checktitlewave[20] = "EXP_5 "
	checktitlewave[3] = "UPS "; checktitlewave[9] = "cal. (Band) "; checktitlewave[15] = "Brolight ";checktitlewave[21] = "EXP_6 "
	checktitlewave[4] = "IPES ";checktitlewave[10] = "Voigt ";checktitlewave[16] = "EXP_3 ";checktitlewave[22] = "EXP_7 "
	checktitlewave[5] = "UPS and IPES ";checktitlewave[11] = "EXP_2 ";checktitlewave[17] = "EXP_4 ";checktitlewave[23] = "EXP_8 "

	make/O/N=(dimsize(checktitlewave,0)) Loadoption_List=0
	make/O/N=(dimsize(checktitlewave,0)) Displayoption_List=0


	dowindow/K Control_Panel
	dowindow/F Control_Panel
	newpanel/K=1/N=Control_Panel/W=(1000,0,1600,350)

	TabControl Tab,tabLabel(0)="menu",tabLabel(1)="load option",tabLabel(2)="display option"
	TabControl Tab,pos={0,0},size={700,800},proc=TabActionProc

	//___menu tab
	Button Load proc=LoadFiles,title="Loadfiles",pos={40,50},size={100,20}
    PopupMenu popup0 title="Directory : ",proc=PopMenu,pos={310,50},value=ReplaceString(",",ReplaceString("FOLDERS:",DataFolderDir(1,root:),""),";")

    ListBox FolderWave,pos={20,90},size={220,150},listWave=Folder_List,selwave=Folder_sel
	ListBox FolderWave,titlewave=FolderList_title,mode=3,proc=ListBoxProc

    ListBox DisplayWave,pos={310,90},size={220,150},listWave=Display_List,selwave=Display_sel
	ListBox DisplayWave,titlewave=DisplayList_title,mode=3,proc=ListBoxProc

	Button Add proc=AddProc,title="Add",pos={90,250},size={100,20}
    Button Rmv proc=RemoveProc,title="Remove all",pos={380,250},size={100,20}

	Button Display1 proc=DisplayProc,title="Display",size={170,50},pos={220,290}

	CheckBox Display_check0 proc=CheckProc,title="normalize ",pos={522,290},side=1
	CheckBox Display_check1 proc=CheckProc,title="offset ",pos={543,309},side=1
	CheckBox Display_check2 proc=CheckProc,title="Tile Verticaly ",pos={508,327},side=1

	//___load option tab
	Titlebox Loadoption title="Loadoption",pos={28,28},fSize=18,frame=0,disable=1
	// GroupBox Loadoption_box pos={28,50},size={380,110},disable=1

	// columncount=0
	columncount = -1
	for(i=0;i<dimsize(checktitlewave,0);i+=1)
		if(mod(i,6)==0)
			columncount+=1
		endif
		// CheckBox $"Loadoption_chk"+num2str(i) proc=CheckProc,title=checktitlewave[i],pos={42+columncount*100,72+mod(i,6)*25},side=0,disable=1
		CheckBox $"Loadoption_chk"+num2str(i) proc=CheckProc,title=checktitlewave[i],pos={42+columncount*150,72+mod(i,6)*38},side=0,disable=1, fSize=14
	endfor

	//___display option tab
	Titlebox Displayoption,title="Displayoption",pos={28,28},fSize=18,frame=0,disable=1
	// GroupBox Displayoption_box,pos={28,200},size={380,110},disable=1

	columncount=-1
	for(i=0;i<dimsize(checktitlewave,0);i+=1)
		if(mod(i,6)==0)
			columncount+=1
		endif
		CheckBox $"Displayoption_chk"+num2str(i) proc=CheckProc,title=checktitlewave[i],pos={42+columncount*150,72+mod(i,6)*38},side=0,disable=1, fsize=14
	endfor
end

Function LoadFiles(ba) : ButtonControl
	// Followed type of data is FT-IR,UV-vis,XRD,UPS,IPES

	STRUCT WMButtonAction &ba

    switch( ba.eventCode )
		case 2: // mouse up
			Variable i,SelectedMode
            Wave w = root:Loadoption_List

			WaveStats/Q w
			if(V_Sum > 1)
				//___Caution
				dowindow/K Caution_panel
                dowindow/F Caution_panel
                NewPanel/K=1/FLT=1/N=Caution_panel/W=(100,200,700,300)
                Titlebox Caution title="Caution! pleaze choose only one load option."
                Titlebox Caution pos={28,28},fSize=18,frame=0
				return 0
			elseif(V_Sum == 0)
				Loadoption("Default")
			elseif(V_Sum == 1)
				for(i=0;i<DimSize(w,0);i++)
					if(w[i] == 1)
						// 0:FT-IR,1:UV-vis,2:XRD,3:UPS,4:IPES
						// 6:cal.FT-IR,7:cal.UV-vis,8:cal.XRD
						// 13:kinetic,14:image_jpg
						// 18:FET,19:CELIV
						Loadoption(num2str(i))
						break
					endif
				endfor
			endif
			break
		case -1: // control being killed
			break
	endswitch
end

Function/S StringConvert(String text)
	//___Some text convert suitable for igor text encoding
	Variable i,StrSearchValue1

	StrSearchValue1 = StrSearch(text,"-",0)
	if(StrSearchValue1 != -1)
		text = ReplaceString("-",text,"_")
	endif

	return text
End

Function TabActionProc(tc) : TabControl
	STRUCT WMTabControlAction& tc
	Variable i,columncount
	Wave checktitlewave=$("root:checktitlewave")

	switch (tc.eventCode)
		case 2:			// Mouse up
			//___menu tab
			Button Load,disable=(tc.tab!=0)
			Button Rmv,disable=(tc.tab!=0)
			Button Add,disable=(tc.tab!=0)
            ListBox FolderWave,disable=(tc.tab!=0)
			ListBox DisplayWave,disable=(tc.tab!=0)
			Button Display1,disable=(tc.tab!=0)
			CheckBox Display_check0,disable=(tc.tab!=0)
			CheckBox Display_check1,disable=(tc.tab!=0)
			CheckBox Display_check2,disable=(tc.tab!=0)
   			PopupMenu popup0,disable=(tc.tab!=0)

			//___load option tab
			Titlebox Loadoption,disable=(tc.tab!=1)
			// GroupBox Loadoption_box,disable=(tc.tab!=1)

			columncount=0
			for(i=0;i<dimsize(checktitlewave,0);i+=1)
				if(mod(i,6)==0)
					columncount+=1
				endif
				// print (tc.tab)
				CheckBox $"Loadoption_chk"+num2str(i),disable=(tc.tab!=1)
			endfor

			//___display option tab
			Titlebox Displayoption,disable=(tc.tab!=2)
			// GroupBox Displayoption_box,disable=(tc.tab!=2)

			columncount=0
			for(i=0;i<dimsize(checktitlewave,0);i+=1)
				if(mod(i,6)==0)
					columncount+=1
				endif
				CheckBox $"Displayoption_chk"+num2str(i),disable=(tc.tab!=2)
			endfor
			break
	endswitch
	return 0
End

Function PopMenu(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			SetDataFolder root:
			String/G popStr = pa.popStr
            String DataFolder,DataList
            Variable i,NumOfList

            SetDataFolder root:$popStr
            Wave/T title = root:FolderList_title
            title[0] = popStr

            DataList = WaveList("*_ywave",";","")
            NumOfList = ItemsInList(DataList, ";")
            Wave/T w = root:Folder_List
            w = ""
            for(i=0;i<NumOfList;i++)
                w[i] = StringFromList(i,DataList,";")
            endfor
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ListBoxProc(lba) : ListBoxControl
	STRUCT WMListboxAction &lba

	NVAR Counter = root:Counter
	SVAR popStr = root:popStr
	Variable row = lba.row,col = lba.col
	Wave/T w_fol = root:Folder_List,w_dis = root:Display_List,w_dir = root:Display_dir

	switch( lba.eventCode )
		case -1: // control being killed
			break
		case 1: // mouse down
			break
		case 3: // double click
        	if(strlen(w_dis[Counter]) == 0)
				w_dis[Counter] = w_fol[row]
				w_dir[Counter] = popStr
				Counter += 1
			else
				Counter = Counter+1
			endif
			break
		case 4: // cell selection
			break
		case 5: // cell selection plus shift key
            strswitch( lba.ctrlname )
                case "FolderWave":
                    break
                case "DisplayWave":
                    w_dis[row] = ""
                    Counter-=1
                    break
            endswitch
			break
		case 6: // begin edit
			break
		case 7: // finish edit
			break
		case 13: // checkbox clicked (Igor 6.2 or later)
			break
	endswitch

	return 0
End

Function AddProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

    NVAR Counter = root:Counter
	SVAR popStr = root:popStr
	Variable i
	Variable/G root:Counter
	Wave/T w_fol = root:Folder_List,w_dis = root:Display_List,w_dir = root:Display_dir
    Wave w_sel = root:Folder_sel
	switch( ba.eventCode )
		case 2: // mouse up
            Wavestats/Q w_sel
			for(i=0;i<V_sum;i++)
				if(w_sel[i] > 0)
                    w_dis[Counter] = w_fol[i]
					w_dir[Counter] = popStr
					Counter += 1
				endif
            endfor
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function RemoveProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

    NVAR Counter = root:Counter
	Variable/G root:Counter
	Wave/T w = root:Display_List,w_dir = root:Display_dir
	switch( ba.eventCode )
		case 2: // mouse up
			w = ""
			w_dir = ""
			Counter = 0
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function DisplayProc(ba) : ButtonControl
	// Followed type of data is FT-IR,UV-vis,XRD,UPS,IPES

	STRUCT WMButtonAction &ba

    switch( ba.eventCode )
		case 2: // mouse up
			Variable i,SelectedMode
			String funcname
            Wave w = root:Displayoption_List

			WaveStats/Q w
			if(V_Sum > 1)
				//___Caution
				dowindow/K Caution_panel
                dowindow/F Caution_panel
                NewPanel/K=1/FLT=1/N=Caution_panel/W=(100,200,700,300)
                Titlebox Caution title="Caution! pleaze choose only one Display option."
                Titlebox Caution pos={28,28},fSize=18,frame=0
				return 0
			elseif(V_Sum == 0)
				Displayoption_Default()
			elseif(V_Sum == 1)
				for(i=0;i<DimSize(w,0);i++)
					if(w[i] == 1)
						if(i == 0)
							// 0:FT-IR
							make/O root:normalize_constant_FT_IR
							Displayoption_0()
							break
						else
							// 1:UV-vis,2:XRD,3:UPS,4:IPES,5:UPSandIPES
							// 6:cal.FT-IR,7:cal.UV-vis,8:cal.XRD,9:cal.Band
							// 13:kinetic,14:image_jpg
							// 18:FET,19:CELIV
							funcname = "Displayoption_"+num2str(i)
							FUNCREF Displayoption_Default Displayoption_num=$funcname
							Displayoption_num()
							break
						endif
					endif
				endfor
			endif
			break
		case -1: // control being killed
			break
	endswitch
end

Function CheckProc(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba
	Variable i
	NVAR SaveCheck = root:SaveCheck
	NVAR Kinetic_doFit = root:Kinetic_doFit
	NVAR IV_doFit = root:IV_doFit

	Wave w_Load = root:Loadoption_List
	Wave w_Disp = root:Displayoption_List
	Wave/T w_Dispwave = root:Display_List
	Wave checktitlewave=$("root:checktitlewave")
	switch( cba.eventCode )
		case 2: // mouse up
				for(i=0;i<dimsize(checktitlewave,0);i+=1)
					if(stringmatch(cba.ctrlname,"Display_check"+num2str(0))==1)
						Variable/G root:Display_check0 = cba.checked
						break
					elseif(stringmatch(cba.ctrlname,"Display_check"+num2str(1))==1)
						Variable/G root:Display_check1 = cba.checked
						break
					elseif(stringmatch(cba.ctrlname,"Display_check"+num2str(2))==1)
						Variable/G root:Display_check2 = cba.checked
						break
					
					//___Loadoption
					elseif(stringmatch(cba.ctrlname,"Loadoption_chk"+num2str(i))==1)
						w_Load[i] = cba.checked
						if(i == 13)
							if(cba.checked == 1)
								// KineticPanel()
							else
								dowindow/K Kinetic_Panel
							endif
							break
						endif
					
					//___Displayoption
					elseif(stringmatch(cba.ctrlname,"Displayoption_chk"+num2str(i))==1)
						w_Disp[i] = cba.checked
						if(i == 14)
							if(cba.checked == 1)
								strswitch(w_Dispwave[0])
									case "":
									//___Caution
									dowindow/K Caution_panel
									dowindow/F Caution_panel
									NewPanel/K=1/FLT=1/N=Caution_panel/W=(100,200,700,300)
									Titlebox Caution title="Caution! pleaze check after choose an image."
									Titlebox Caution pos={28,28},fSize=18,frame=0
									return 0
									break
								default :
									// GIFPanel()
									break
								endswitch
							else
								dowindow/K GIF_Panel
							endif
							break
						endif

						// CELIV Panel
						if(i == 19)
							if(cba.checked == 1)
								// celivpanel()
							else
								dowindow/K Device_Panel
							endif
							break
						endif
					
					//GIF_Panel
					elseif(stringmatch(cba.ctrlname,"save_check")==1)
						SaveCheck = cba.checked
						break
					
					//Kinetic_Panel
					elseif(stringmatch(cba.ctrlname,"Kinetic_doFit")==1)
						Kinetic_doFit = cba.checked
						break
					endif
				endfor

		case -1: // control being killed
			break
	endswitch
	return 0
End
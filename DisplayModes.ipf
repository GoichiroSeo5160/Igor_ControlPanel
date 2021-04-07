#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave acces

Function ColorGeneretor(Variable numberOfColors)
	Variable i,j
	
	Make/O/N=(numberOfColors,3) root:rgb
	Wave w = root:rgb

	SetScale x,0,65535,w
	// w[][0]= abs(enoise(65535))		
	// w[][1]= abs(enoise(65535))	
	// w[][2]= abs(enoise(65535))

	make/O/N=(numberOfColors,3) root:start_color
	make/O/N=(numberOfColors,3) root:end_color
	wave w_start = root:start_color
	wave w_end = root:end_color

	w_start[0][0] = 65535
	w_start[0][1] = 51143
	w_start[0][2] = 30840

	w_end[0][0] = 1
	w_end[0][1] = 9611
	w_end[0][2] = 39321


	for(i=0;i<numberOfColors;i++)
		for(j=0;j<3;j++)
			if(w_start[0][j] > w_end[0][j])
				w[i][j]= ceil(w_start[0][j]) - ceil(i*(abs(w_start[0][j]-w_end[0][j]+280)/numberOfColors))
			elseif(w_start[0][j] < w_end[0][j])
				w[i][j]= w_start[0][j] + i*(abs(w_start[0][j]-w_end[0][j])/numberOfColors)
			elseif(w_start[0][j] == w_end[0][j])
				w[][j]= w_start[0][j]
			endif
		endfor
	endfor
End

Function Displayoption_Default()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={0,bottom}
			ModifyGraph noLabel($axis)=1,tick(axis0)=3
			ModifyGraph margin(left)=34
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Current\f00 / A"
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
		endfor

		SetAxis Left *,*
		Label Left "\Z18\f02Current\f00 / A"
		ModifyGraph margin(left)=59
	endif

	//__about axies
	ModifyGraph tick=2,mirror=1,minor=1
	Label bottom "\Z18\f02Voltage\f00 / V"

	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,1/V_max}
		endfor
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

//___FT-IR
Function Displayoption_0()  

    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={4000,bottom}
			ModifyGraph noLabel($axis)=1,tick($axis)=3,zero($axis)=1
			SetAxis/A/R $axis
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"
		ModifyGraph margin(left)=34
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
		endfor

		SetAxis Left *,*
		Label Left "\Z18\f02Intensity\f00 / arb. units"
		ModifyGraph margin(left)=59
	endif

	//__about axies
	ModifyGraph mirror=1,minor=1,tick(bottom)=2
	Label bottom "\Z18\f02WaveNumber\f00 / cm\S-1"
    SetAxis/A/R bottom

	//___normalize
	if(check0 == 1)
        Wave w_nor = root:normalize_constant_FT_IR
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,-1/V_max},offset($w_y[i])={0,1}

            w_nor[i] = (V_max-V_min)/V_max
            axis = "axis"+num2str(i)
            if(check2 == 1)
                SetAxis $axis 0,w_nor[i]
            else
                WaveStats/Q w_nor
                SetAxis Left V_max,0
            endif
		endfor
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.2,-0.2,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

//___UV-vis
Function Displayoption_1()  

    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={0,bottom}
			ModifyGraph noLabel($axis)=1,tick(axis0)=3
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"
		ModifyGraph margin(left)=34
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
		endfor

		SetAxis Left *,*
		Label Left "\Z18\f02Intensity\f00 / arb. units"
		ModifyGraph margin(left)=59
	endif

	//__about axies
	ModifyGraph tick=2,mirror=1,minor=1
	Label bottom "\Z18\f02Wavelength\f00 / nm"

	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,1/V_max}
		endfor
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

//___XRD
Function Displayoption_2()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_theta,Displaywave_y,Displaywave_ycal,w_theta,w_ycal,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_theta = ReplaceString("_ywave",w_y[i],"_theta")
            w_ycal = ReplaceString("_ywave",w_y[i],"_ycal")
			DisplayWave_theta = "root:'"+w_dir[i]+"':'"+w_theta+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            Displaywave_ycal = "root:'"+w_dir[i]+"':'"+w_ycal+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_theta
			AppendtoGraph/W=Display_graph/C=(65535,0,0)/L=$axis $Displaywave_ycal vs $DisplayWave_theta

            ModifyGraph mode($w_y[i])=2,lsize($w_y[i])=2
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={0,bottom}
			ModifyGraph noLabel($axis)=1,tick(axis0)=3
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"
		ModifyGraph margin(left)=34
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_theta = ReplaceString("_ywave",w_y[i],"_theta")
            w_ycal = ReplaceString("_ywave",w_y[i],"_ycal")
			DisplayWave_theta = "root:'"+w_dir[i]+"':'"+w_theta+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            Displaywave_ycal = "root:'"+w_dir[i]+"':'"+w_ycal+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_theta
			AppendtoGraph/W=Display_graph/C=(65535,0,0) $Displaywave_ycal vs $DisplayWave_theta

            ModifyGraph mode($w_y[i])=2,lsize($w_y[i])=2
		endfor

		SetAxis Left *,*
		Label Left "\Z18\f02Intensity\f00 / arb. units"
		ModifyGraph margin(left)=59
	endif

	//__about axies
	ModifyGraph tick=2,mirror=1,minor=1
	Label bottom "\Z18\f022\$WMTEX$ \theta \$/WMTEX$\f00 / degree"

	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i++)
            w_ycal = ReplaceString("_ywave",w_y[i],"_ycal")
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,1/V_max},muloffset($w_ycal)={0,1/V_max}
		endfor
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
            w_ycal = ReplaceString("_ywave",w_y[i],"_ycal")
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,-V_min},offset($w_ycal)={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

//___UPS
Function Displayoption_3()

	Variable mode_1,mode_2
    Wave/T w_y = root:Display_List,w_dir = root:Display_dir
    mode_1 = Stringmatch(w_y[0],"*VB*")
    mode_2 = Stringmatch(w_y[1],"*cutoff*")

    if(mode_1 == 1 && mode_2 == 1)
        Displayoption_UPS_VBandCutoff()
    elseif(mode_1 == 1 && mode_2 == 0)
        Displayoption_UPS_VB()
    elseif(mode_1 == 0 && mode_2 == 1)
        Displayoption_UPS_Cutoff()
    else
        Displayoption_UPS_CutoffandVB()
    endif
end

Function Displayoption_UPS_VBandCutoff()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i,V_max_atDefault=0
	Wave w_rgb = root:rgb
    String DisplayWave_VB_x,DisplayWave_Cutoff_x,Displaywave_VB,Displaywave_Cutoff,w_VB_x,w_Cutoff_x
    String axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i=i+2)
			axis = "axis"+num2str(i)
			w_VB_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_VB_x = "root:'"+w_dir[i]+"':'"+w_VB_x+"'"
			Displaywave_VB = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            w_Cutoff_x = ReplaceString("_ywave",w_y[i+1],"_xwave")
			DisplayWave_Cutoff_x = "root:'"+w_dir[i+1]+"':'"+w_Cutoff_x+"'"
            Displaywave_Cutoff = "root:'"+w_dir[i+1]+"':'"+w_y[i+1]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("VB_"+axis)/B=$("VB_bottom") $Displaywave_VB vs $DisplayWave_VB_x
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("Cutoff_"+axis)/B=$("Cutoff_bottom") $Displaywave_Cutoff vs $DisplayWave_Cutoff_x
			
            //___about vertical axis
            WaveStats/Q $DisplayWave_Cutoff_x
            SetAxis/A/R Cutoff_bottom 18,16
			ModifyGraph axisEnab($("Cutoff_"+axis))={i/Counter,2*((i/2)+1)/Counter},freePos($("Cutoff_"+axis))={V_max,Cutoff_bottom}
			ModifyGraph noLabel($("Cutoff_"+axis))=1,tick($("Cutoff_"+axis))=3,zero($("Cutoff_"+axis))=1

            WaveStats/Q $DisplayWave_VB_x
            SetAxis/A/R VB_bottom 15,V_min
			ModifyGraph axisEnab($("VB_"+axis))={i/Counter,2*((i/2)+1)/Counter},freePos($("VB_"+axis))={V_max,VB_bottom}
			ModifyGraph noLabel($("VB_"+axis))=1,tick($("VB_"+axis))=3,zero($("VB_"+axis))=1,mirror($("VB_"+axis))=1

            WaveStats/Q/R=[45,300] $Displaywave_VB
            SetAxis $("VB_"+axis) 0,V_max
		endfor

        //___about horiznal axis
        Label VB_bottom "\Z18\f02Binding energy\f00 / eV"
        axis = "axis"+num2str(0)
        ModifyGraph tick(Cutoff_bottom)=2,mirror(Cutoff_bottom)=1,tick(VB_bottom)=2,mirror(VB_bottom)=1,minor=1
        ModifyGraph axisEnab(Cutoff_bottom)={0,0.20},axisEnab(VB_bottom)={0.25,1}
	    ModifyGraph freePos(Cutoff_bottom)={0,$("Cutoff_"+axis)},freePos(VB_bottom)={0,$("VB_"+axis)}
        Modifygraph lblPos(VB_bottom)=40,lblLatPos(VB_bottom)=-40
		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"

        ModifyGraph margin(left)=34,margin(bottom)=42
	else
        //___Defalut
		for(i=0;i<Counter;i=i+2)
			w_VB_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_VB_x = "root:'"+w_dir[i]+"':'"+w_VB_x+"'"
			Displaywave_VB = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            w_Cutoff_x = ReplaceString("_ywave",w_y[i+1],"_xwave")
			DisplayWave_Cutoff_x = "root:'"+w_dir[i+1]+"':'"+w_Cutoff_x+"'"
            Displaywave_Cutoff = "root:'"+w_dir[i+1]+"':'"+w_y[i+1]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("VB_Left")/B=$("VB_bottom") $Displaywave_VB vs $DisplayWave_VB_x
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("Cutoff_Left")/B=$("Cutoff_bottom") $Displaywave_Cutoff vs $DisplayWave_Cutoff_x
		
            WaveStats/Q/R=[45,300] $Displaywave_VB
            if(V_max > V_max_atDefault)
                V_max_atDefault = V_max
            endif
        endfor

        //___about vertical axis
        WaveStats/Q $DisplayWave_Cutoff_x
        SetAxis/A/R Cutoff_bottom 18,16
        ModifyGraph freePos($("Cutoff_Left"))={V_max,Cutoff_bottom},noLabel($("Cutoff_Left"))=1,tick($("Cutoff_Left"))=3
       
        WaveStats/Q $DisplayWave_VB_x
        SetAxis/A/R VB_bottom 15,V_min
        ModifyGraph freePos($("VB_Left"))={V_max,VB_bottom},noLabel($("VB_Left"))=1,tick($("VB_Left"))=3,mirror($("VB_Left"))=1

        SetAxis $("VB_Left") 0,V_max_atDefault

        //___about horiznal axis
        Label VB_bottom "\Z18\f02Binding energy\f00 / eV"
        ModifyGraph tick(Cutoff_bottom)=2,mirror(Cutoff_bottom)=1,tick(VB_bottom)=2,mirror(VB_bottom)=1,minor=1
        ModifyGraph axisEnab(Cutoff_bottom)={0,0.20},axisEnab(VB_bottom)={0.25,1}
	    ModifyGraph freePos(Cutoff_bottom)={0,$("Cutoff_Left")},freePos(VB_bottom)={0,$("VB_Left")}
        Modifygraph lblPos(VB_bottom)=40,lblLatPos(VB_bottom)=-40
		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"

        ModifyGraph margin(left)=34,margin(bottom)=42
	endif

	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i=i+2)
        	Displaywave_VB = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q/R=[45,300] $Displaywave_VB
			Modifygraph muloffset($w_y[i])={0,1/V_max}

			Displaywave_Cutoff = "root:'"+w_dir[i+1]+"':'"+w_y[i+1]+"'"
            WaveStats/Q $Displaywave_Cutoff
			Modifygraph muloffset($w_y[i+1])={0,1/V_max}
		endfor

        if(check2 == 1)
            for(i=0;i<Counter;i=i+2)
                axis = "axis"+num2str(i)
                SetAxis $("Cutoff_"+axis) 0,1
                SetAxis $("VB_"+axis) 0,1
            endfor
        else
            SetAxis Cutoff_Left 0,1
            SetAxis VB_Left 0,1
        endif
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i=i+2)
        	Displaywave_VB = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_VB
			Modifygraph offset($w_y[i])={0,-V_min}

			Displaywave_Cutoff = "root:'"+w_dir[i+1]+"':'"+w_y[i+1]+"'"
            WaveStats/Q $Displaywave_Cutoff
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i=i+2)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $("Cutoff_"+axis),textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-2;i=i+2)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

Function Displayoption_UPS_CutoffandVB()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i,V_max_atDefault=0
	Wave w_rgb = root:rgb
    String DisplayWave_VB_x,DisplayWave_Cutoff_x,Displaywave_VB,Displaywave_Cutoff,w_VB_x,w_Cutoff_x
    String axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=1;i<Counter+1;i=i+2)
			axis = "axis"+num2str(i)
			w_VB_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_VB_x = "root:'"+w_dir[i]+"':'"+w_VB_x+"'"
			Displaywave_VB = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            w_Cutoff_x = ReplaceString("_ywave",w_y[i-1],"_xwave")
			DisplayWave_Cutoff_x = "root:'"+w_dir[i-1]+"':'"+w_Cutoff_x+"'"
            Displaywave_Cutoff = "root:'"+w_dir[i-1]+"':'"+w_y[i-1]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("VB_"+axis)/B=$("VB_bottom") $Displaywave_VB vs $DisplayWave_VB_x
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("Cutoff_"+axis)/B=$("Cutoff_bottom") $Displaywave_Cutoff vs $DisplayWave_Cutoff_x
			
            //___about vertical axis
            WaveStats/Q $DisplayWave_Cutoff_x
            SetAxis/A/R Cutoff_bottom 18,16
			ModifyGraph axisEnab($("Cutoff_"+axis))={(i-1)/Counter,2*(((i-1)/2)+1)/Counter},freePos($("Cutoff_"+axis))={V_max,Cutoff_bottom}
			ModifyGraph noLabel($("Cutoff_"+axis))=1,tick($("Cutoff_"+axis))=3,zero($("Cutoff_"+axis))=1

            WaveStats/Q $DisplayWave_VB_x
            SetAxis/A/R VB_bottom 15,V_min
			ModifyGraph axisEnab($("VB_"+axis))={(i-1)/Counter,2*(((i-1)/2)+1)/Counter},freePos($("VB_"+axis))={V_max,VB_bottom}
			ModifyGraph noLabel($("VB_"+axis))=1,tick($("VB_"+axis))=3,zero($("VB_"+axis))=1,mirror($("VB_"+axis))=1

            WaveStats/Q/R=[45,300] $Displaywave_VB
            SetAxis $("VB_"+axis) 0,V_max
		endfor

        //___about horiznal axis
        Label VB_bottom "\Z18\f02Binding energy\f00 / eV"
        axis = "axis"+num2str(1)
        ModifyGraph tick(Cutoff_bottom)=2,mirror(Cutoff_bottom)=1,tick(VB_bottom)=2,mirror(VB_bottom)=1,minor=1
        ModifyGraph axisEnab(Cutoff_bottom)={0,0.20},axisEnab(VB_bottom)={0.25,1}
	    ModifyGraph freePos(Cutoff_bottom)={0,$("Cutoff_"+axis)},freePos(VB_bottom)={0,$("VB_"+axis)}
        Modifygraph lblPos(VB_bottom)=40,lblLatPos(VB_bottom)=-40
		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"

        ModifyGraph margin(left)=34,margin(bottom)=42
	else
        //___Defalut
		for(i=1;i<Counter+1;i=i+2)
			w_VB_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_VB_x = "root:'"+w_dir[i]+"':'"+w_VB_x+"'"
			Displaywave_VB = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            w_Cutoff_x = ReplaceString("_ywave",w_y[i-1],"_xwave")
			DisplayWave_Cutoff_x = "root:'"+w_dir[i-1]+"':'"+w_Cutoff_x+"'"
            Displaywave_Cutoff = "root:'"+w_dir[i-1]+"':'"+w_y[i-1]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("VB_Left")/B=$("VB_bottom") $Displaywave_VB vs $DisplayWave_VB_x
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("Cutoff_Left")/B=$("Cutoff_bottom") $Displaywave_Cutoff vs $DisplayWave_Cutoff_x
		
            WaveStats/Q/R=[45,300] $Displaywave_VB
            if(V_max > V_max_atDefault)
                V_max_atDefault = V_max
            endif
        endfor

        //___about vertical axis
        WaveStats/Q $DisplayWave_Cutoff_x
        SetAxis/A/R Cutoff_bottom 18,16
        ModifyGraph freePos($("Cutoff_Left"))={V_max,Cutoff_bottom},noLabel($("Cutoff_Left"))=1,tick($("Cutoff_Left"))=3
       
        WaveStats/Q $DisplayWave_VB_x
        SetAxis/A/R VB_bottom 15,V_min
        ModifyGraph freePos($("VB_Left"))={V_max,VB_bottom},noLabel($("VB_Left"))=1,tick($("VB_Left"))=3,mirror($("VB_Left"))=1

        SetAxis $("VB_Left") 0,V_max_atDefault

        //___about horiznal axis
        Label VB_bottom "\Z18\f02Binding energy\f00 / eV"
        ModifyGraph tick(Cutoff_bottom)=2,mirror(Cutoff_bottom)=1,tick(VB_bottom)=2,mirror(VB_bottom)=1,minor=1
        ModifyGraph axisEnab(Cutoff_bottom)={0,0.20},axisEnab(VB_bottom)={0.25,1}
	    ModifyGraph freePos(Cutoff_bottom)={0,$("Cutoff_Left")},freePos(VB_bottom)={0,$("VB_Left")}
        Modifygraph lblPos(VB_bottom)=40,lblLatPos(VB_bottom)=-40
		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"

        ModifyGraph margin(left)=34,margin(bottom)=42
	endif

	//___normalize
	if(check0 == 1)
		for(i=1;i<Counter+1;i=i+2)
        	Displaywave_VB = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q/R=[45,300] $Displaywave_VB
			Modifygraph muloffset($w_y[i])={0,1/V_max}

			Displaywave_Cutoff = "root:'"+w_dir[i-1]+"':'"+w_y[i-1]+"'"
            WaveStats/Q $Displaywave_Cutoff
			Modifygraph muloffset($w_y[i-1])={0,1/V_max}
		endfor

        if(check2 == 1)
            for(i=1;i<Counter+1;i=i+2)
                axis = "axis"+num2str(i)
                SetAxis $("Cutoff_"+axis) 0,1
                SetAxis $("VB_"+axis) 0,1
            endfor
        else
            SetAxis Cutoff_Left 0,1
            SetAxis VB_Left 0,1
        endif
	endif

	//___offset
	if(check1 == 1)
		for(i=1;i<Counter+1;i=i+2)
        	Displaywave_VB = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_VB
			Modifygraph offset($w_y[i])={0,-V_min}

			Displaywave_Cutoff = "root:'"+w_dir[i-1]+"':'"+w_y[i-1]+"'"
            WaveStats/Q $Displaywave_Cutoff
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=1;i<Counter+1;i=i+2)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $("Cutoff_"+axis),textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=1;i<Counter-1;i=i+2)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

Function Displayoption_UPS_VB()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
            WaveStats/Q/R=[550,650] $DisplayWave_y
            Setaxis $axis 0,V_max
            WaveStats/Q $DisplayWave_x
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={V_max,bottom}
			ModifyGraph noLabel($axis)=1,tick($axis)=3,zero($axis)=1
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
		endfor

        WaveStats/Q/R=[550,650] $DisplayWave_y
        Setaxis Left 0,V_max
		Label Left "\Z18\f02Intensity\f00 / arb. units"
	endif

	//__about axies
	ModifyGraph tick(bottom)=2,mirror=1,minor=1
	Label bottom "\Z18\f02Binding energy\f00 / eV"
    WaveStats/Q $DisplayWave_x
    SetAxis/A/R bottom 5,V_min


	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q/R=[550,650] $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,1/V_max}
		endfor

        if(check2 == 1)
            for(i=0;i<Counter;i++)
                axis = "axis"+num2str(i)
                SetAxis $axis 0,1
            endfor
        else
            SetAxis Left 0,1
        endif
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

Function Displayoption_UPS_Cutoff()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
            WaveStats/Q $DisplayWave_x
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={V_max,bottom}
			ModifyGraph noLabel($axis)=1,tick($axis)=3,zero($axis)=1
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
		endfor

		SetAxis Left *,*
		Label Left "\Z18\f02Intensity\f00 / arb. units"
	endif

	//__about axies
	ModifyGraph tick(bottom)=2,mirror=1,minor=1
	Label bottom "\Z18\f02Binding energy\f00 / eV"
    SetAxis/A/R bottom 18,16


	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,1/V_max}
		endfor
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.25,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

//___IPES
Function Displayoption_4()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,Displaywave_smt,w_x,w_smt,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
            w_smt = ReplaceString("_ywave",w_y[i],"_smt")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			Displaywave_smt = "root:'"+w_dir[i]+"':'"+w_smt+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			AppendtoGraph/W=Display_graph/C=(65535,0,0)/L=$axis $Displaywave_smt vs $DisplayWave_x
			
            WaveStats/Q $DisplayWave_x
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={V_max,bottom}
			ModifyGraph noLabel($axis)=1,tick($axis)=3,zero($axis)=1
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
            w_smt = ReplaceString("_ywave",w_y[i],"_smt")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			Displaywave_smt = "root:'"+w_dir[i]+"':'"+w_smt+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
			AppendtoGraph/W=Display_graph/C=(65535,0,0) $Displaywave_smt vs $DisplayWave_x

		endfor

		SetAxis Left *,*
		Label Left "\Z18\f02Intensity\f00 / arb. units"
	endif

	//__about axies
	ModifyGraph tick(bottom)=2,mirror=1,minor=1
	Label bottom "\Z18\f02Binding energy\f00 / eV"
    SetAxis/A/R bottom

	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i++)
            w_smt = ReplaceString("_ywave",w_y[i],"_smt")
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,1/V_max},muloffset($w_smt)={0,1/V_max}
		endfor
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
            w_smt = ReplaceString("_ywave",w_y[i],"_smt")
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,-V_min},offset($w_smt)={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

//___UPS and IPES
Function Displayoption_5()

    Variable mode_1,mode_2
    Wave/T w_y = root:Display_List,w_dir = root:Display_dir
    mode_1 = Stringmatch(w_y[0],"*VB*")
    mode_2 = Stringmatch(w_y[1],"*IPES*")

    if(mode_1 == 1 && mode_2 == 1)
        Displayoption_UPS_and_IPES()
    elseif(mode_1 == 0 && mode_2 == 0)
        Displayoption_IPES_and_UPS()
    else
        dowindow/K Caution_panel
        dowindow/F Caution_panel
        NewPanel/K=1/FLT=1/N=Caution_panel/W=(100,200,700,300)
        Titlebox Caution title="Caution! Choose VB and IPES in alternatly"
        Titlebox Caution pos={28,28},fSize=18,frame=0
		return 0
    endif
end

Function Displayoption_UPS_and_IPES()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i,V_max_atDefault=0
	Wave w_rgb = root:rgb
    String DisplayWave_UPS_x,DisplayWave_IPES_x,Displaywave_UPS,Displaywave_IPES,w_UPS_x,w_IPES_x
    String axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i=i+2)
			axis = "axis"+num2str(i)
			w_UPS_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_UPS_x = "root:'"+w_dir[i]+"':'"+w_UPS_x+"'"
			Displaywave_UPS = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            w_IPES_x = ReplaceString("_ywave",w_y[i+1],"_xwave")
			DisplayWave_IPES_x = "root:'"+w_dir[i+1]+"':'"+w_IPES_x+"'"
            Displaywave_IPES = "root:'"+w_dir[i+1]+"':'"+w_y[i+1]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("UPS_"+axis)/B=$("UPS_bottom") $Displaywave_UPS vs $DisplayWave_UPS_x
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("IPES_"+axis)/B=$("IPES_bottom") $Displaywave_IPES vs $DisplayWave_IPES_x
			
            //___about vertical axis
            WaveStats/Q $DisplayWave_IPES_x
            SetAxis/A/R IPES_bottom 0,-7
			ModifyGraph axisEnab($("IPES_"+axis))={i/Counter,2*((i/2)+1)/Counter},freePos($("IPES_"+axis))={V_min,IPES_bottom}
			ModifyGraph noLabel($("IPES_"+axis))=1,tick($("IPES_"+axis))=3,zero($("IPES_"+axis))=1

            WaveStats/Q $DisplayWave_UPS_x
            SetAxis/A/R UPS_bottom 15,0
			ModifyGraph axisEnab($("UPS_"+axis))={i/Counter,2*((i/2)+1)/Counter},freePos($("UPS_"+axis))={V_max,UPS_bottom}
			ModifyGraph noLabel($("UPS_"+axis))=1,tick($("UPS_"+axis))=3,zero($("UPS_"+axis))=1,mirror($("UPS_"+axis))=1

            WaveStats/Q/R=[45,300] $Displaywave_UPS
            SetAxis $("UPS_"+axis) 0,V_max
		endfor

        //___about horiznal axis
        Label UPS_bottom "\Z18\f02Binding energy\f00 / eV"
        axis = "axis"+num2str(0)
        ModifyGraph tick(IPES_bottom)=2,mirror(IPES_bottom)=1,tick(UPS_bottom)=2,mirror(UPS_bottom)=1,minor=1
        ModifyGraph axisEnab(IPES_bottom)={0.5,1.0},axisEnab(UPS_bottom)={0,0.5}
	    ModifyGraph freePos(IPES_bottom)={0,$("IPES_"+axis)},freePos(UPS_bottom)={0,$("UPS_"+axis)}
        Modifygraph lblPos(UPS_bottom)=40,lblLatPos(UPS_bottom)=85,sep(IPES_bottom)=2
		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"

        ModifyGraph margin(left)=34,margin(bottom)=42
	else
        //___Defalut
		for(i=0;i<Counter;i=i+2)
			w_UPS_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_UPS_x = "root:'"+w_dir[i]+"':'"+w_UPS_x+"'"
			Displaywave_UPS = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            w_IPES_x = ReplaceString("_ywave",w_y[i+1],"_xwave")
			DisplayWave_IPES_x = "root:'"+w_dir[i+1]+"':'"+w_IPES_x+"'"
            Displaywave_IPES = "root:'"+w_dir[i+1]+"':'"+w_y[i+1]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("UPS_Left")/B=$("UPS_bottom") $Displaywave_UPS vs $DisplayWave_UPS_x
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("IPES_Left")/B=$("IPES_bottom") $Displaywave_IPES vs $DisplayWave_IPES_x
		
            WaveStats/Q/R=[45,300] $Displaywave_UPS
            if(V_max > V_max_atDefault)
                V_max_atDefault = V_max
            endif
        endfor

        //___about vertical axis
        WaveStats/Q $DisplayWave_IPES_x
        SetAxis/A/R IPES_bottom 0,-7
        ModifyGraph freePos($("IPES_Left"))={V_min,IPES_bottom},noLabel($("IPES_Left"))=1,tick($("IPES_Left"))=3
       
        WaveStats/Q $DisplayWave_UPS_x
        SetAxis/A/R UPS_bottom 15,V_min
        ModifyGraph freePos($("UPS_Left"))={V_max,UPS_bottom},noLabel($("UPS_Left"))=1,tick($("UPS_Left"))=3,mirror($("UPS_Left"))=1

        SetAxis $("UPS_Left") 0,V_max_atDefault

        //___about horiznal axis
        Label UPS_bottom "\Z18\f02Binding energy\f00 / eV"
        ModifyGraph tick(IPES_bottom)=2,mirror(IPES_bottom)=1,tick(UPS_bottom)=2,mirror(UPS_bottom)=1,minor=1
        Modifygraph axisEnab(IPES_bottom)={0.5,1.0},axisEnab(UPS_bottom)={0,0.5}
	    ModifyGraph freePos(IPES_bottom)={0,$("IPES_Left")},freePos(UPS_bottom)={0,$("UPS_Left")}
        Modifygraph lblPos(UPS_bottom)=40,lblLatPos(UPS_bottom)=85,sep(IPES_bottom)=2
		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"

        ModifyGraph margin(left)=34,margin(bottom)=42
	endif

	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i=i+2)
        	Displaywave_UPS = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q/R=[45,300] $Displaywave_UPS
			Modifygraph muloffset($w_y[i])={0,1/V_max}

			Displaywave_IPES = "root:'"+w_dir[i+1]+"':'"+w_y[i+1]+"'"
            WaveStats/Q $Displaywave_IPES
			Modifygraph muloffset($w_y[i+1])={0,1/V_max}
		endfor

        if(check2 == 1)
            for(i=0;i<Counter;i=i+2)
                axis = "axis"+num2str(i)
                SetAxis $("IPES_"+axis) 0,1
                SetAxis $("UPS_"+axis) 0,1
            endfor
        else
            SetAxis IPES_Left 0,1
            SetAxis UPS_Left 0,1
        endif
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i=i+2)
        	Displaywave_UPS = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_UPS
			Modifygraph offset($w_y[i])={0,-V_min}

			Displaywave_IPES = "root:'"+w_dir[i+1]+"':'"+w_y[i+1]+"'"
            WaveStats/Q $Displaywave_IPES
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i=i+2)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $("IPES_"+axis),xcoord = $("UPS_bottom"),textxjust=1
			DrawText 0,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-2;i=i+2)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

Function Displayoption_IPES_and_UPS()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i,V_max_atDefault=0
	Wave w_rgb = root:rgb
    String DisplayWave_UPS_x,DisplayWave_IPES_x,Displaywave_UPS,Displaywave_IPES,w_UPS_x,w_IPES_x
    String axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=1;i<Counter+1;i=i+2)
			axis = "axis"+num2str(i)
			w_UPS_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_UPS_x = "root:'"+w_dir[i]+"':'"+w_UPS_x+"'"
			Displaywave_UPS = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            w_IPES_x = ReplaceString("_ywave",w_y[i-1],"_xwave")
			DisplayWave_IPES_x = "root:'"+w_dir[i-1]+"':'"+w_IPES_x+"'"
            Displaywave_IPES = "root:'"+w_dir[i-1]+"':'"+w_y[i-1]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("UPS_"+axis)/B=$("UPS_bottom") $Displaywave_UPS vs $DisplayWave_UPS_x
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("IPES_"+axis)/B=$("IPES_bottom") $Displaywave_IPES vs $DisplayWave_IPES_x
			
            //___about vertical axis
            WaveStats/Q $DisplayWave_IPES_x
            SetAxis/A/R IPES_bottom 0,-7
			ModifyGraph axisEnab($("IPES_"+axis))={(i-1)/Counter,2*(((i-1)/2)+1)/Counter},freePos($("IPES_"+axis))={V_min,IPES_bottom}
			ModifyGraph noLabel($("IPES_"+axis))=1,tick($("IPES_"+axis))=3,zero($("IPES_"+axis))=1

            WaveStats/Q $DisplayWave_UPS_x
            SetAxis/A/R UPS_bottom 15,0
			ModifyGraph axisEnab($("UPS_"+axis))={(i-1)/Counter,2*(((i-1)/2)+1)/Counter},freePos($("UPS_"+axis))={V_max,UPS_bottom}
			ModifyGraph noLabel($("UPS_"+axis))=1,tick($("UPS_"+axis))=3,zero($("UPS_"+axis))=1,mirror($("UPS_"+axis))=1

            WaveStats/Q/R=[45,300] $Displaywave_UPS
            SetAxis $("UPS_"+axis) 0,V_max
		endfor

        //___about horiznal axis
        Label UPS_bottom "\Z18\f02Binding energy\f00 / eV"
        axis = "axis"+num2str(1)
        ModifyGraph tick(IPES_bottom)=2,mirror(IPES_bottom)=1,tick(UPS_bottom)=2,mirror(UPS_bottom)=1,minor=1
        ModifyGraph axisEnab(IPES_bottom)={0.5,1},axisEnab(UPS_bottom)={0,0.5}
	    ModifyGraph freePos(IPES_bottom)={0,$("IPES_"+axis)},freePos(UPS_bottom)={0,$("UPS_"+axis)}
        Modifygraph lblPos(UPS_bottom)=40,lblLatPos(UPS_bottom)=85,sep(IPES_bottom)=2
		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"

        ModifyGraph margin(left)=34,margin(bottom)=42
	else
        //___Defalut
		for(i=1;i<Counter+1;i=i+2)
			w_UPS_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_UPS_x = "root:'"+w_dir[i]+"':'"+w_UPS_x+"'"
			Displaywave_UPS = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
            w_IPES_x = ReplaceString("_ywave",w_y[i-1],"_xwave")
			DisplayWave_IPES_x = "root:'"+w_dir[i-1]+"':'"+w_IPES_x+"'"
            Displaywave_IPES = "root:'"+w_dir[i-1]+"':'"+w_y[i-1]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("UPS_Left")/B=$("UPS_bottom") $Displaywave_UPS vs $DisplayWave_UPS_x
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$("IPES_Left")/B=$("IPES_bottom") $Displaywave_IPES vs $DisplayWave_IPES_x
		
            WaveStats/Q/R=[45,300] $Displaywave_UPS
            if(V_max > V_max_atDefault)
                V_max_atDefault = V_max
            endif
        endfor

        //___about vertical axis
        WaveStats/Q $DisplayWave_IPES_x
        SetAxis/A/R IPES_bottom 0,-7
        ModifyGraph freePos($("IPES_Left"))={V_min,IPES_bottom},noLabel($("IPES_Left"))=1,tick($("IPES_Left"))=3
       
        WaveStats/Q $DisplayWave_UPS_x
        SetAxis/A/R UPS_bottom 15,0
        ModifyGraph freePos($("UPS_Left"))={V_max,UPS_bottom},noLabel($("UPS_Left"))=1,tick($("UPS_Left"))=3,mirror($("UPS_Left"))=1

        SetAxis $("UPS_Left") 0,V_max_atDefault

        //___about horiznal axis
        Label UPS_bottom "\Z18\f02Binding energy\f00 / eV"
        ModifyGraph tick(IPES_bottom)=2,mirror(IPES_bottom)=1,tick(UPS_bottom)=2,mirror(UPS_bottom)=1,minor=1
        ModifyGraph axisEnab(IPES_bottom)={0,0.20},axisEnab(UPS_bottom)={0.25,1}
	    ModifyGraph freePos(IPES_bottom)={0,$("IPES_Left")},freePos(UPS_bottom)={0,$("UPS_Left")}
        Modifygraph lblPos(UPS_bottom)=40,lblLatPos(UPS_bottom)=85,sep(IPES_bottom)=2
		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02Intensity\f00 / arb. units"

        ModifyGraph margin(left)=34,margin(bottom)=42
	endif

	//___normalize
	if(check0 == 1)
		for(i=1;i<Counter+1;i=i+2)
        	Displaywave_UPS = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q/R=[45,300] $Displaywave_UPS
			Modifygraph muloffset($w_y[i])={0,1/V_max}

			Displaywave_IPES = "root:'"+w_dir[i-1]+"':'"+w_y[i-1]+"'"
            WaveStats/Q $Displaywave_IPES
			Modifygraph muloffset($w_y[i-1])={0,1/V_max}
		endfor

        if(check2 == 1)
            for(i=1;i<Counter+1;i=i+2)
                axis = "axis"+num2str(i)
                SetAxis $("IPES_"+axis) 0,1
                SetAxis $("UPS_"+axis) 0,1
            endfor
        else
            SetAxis IPES_Left 0,1
            SetAxis UPS_Left 0,1
        endif
	endif

	//___offset
	if(check1 == 1)
		for(i=1;i<Counter+1;i=i+2)
        	Displaywave_UPS = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_UPS
			Modifygraph offset($w_y[i])={0,-V_min}

			Displaywave_IPES = "root:'"+w_dir[i-1]+"':'"+w_y[i-1]+"'"
            WaveStats/Q $Displaywave_IPES
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=1;i<Counter+1;i=i+2)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $("IPES_"+axis),textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=1;i<Counter-1;i=i+2)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

//___Image for EA
Function Displayoption_14()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph

	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		Displaywave_y = "root:'"+w_dir[0]+"':'"+w_y[0]+"'"
		AppendImage/W=Display_graph $Displaywave_y
		//about axis
		ModifyGraph tick=3,noLabel=2,axThick=0,margin=2

		for(i=1;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendImage/W=Display_graph $Displaywave_y
		endfor
	else
		//___Default
		Displaywave_y = "root:'"+w_dir[0]+"':'"+w_y[0]+"'"
		AppendImage/W=Display_graph $Displaywave_y
		//about axis
		ModifyGraph tick=3,noLabel=2,axThick=0,margin=2

		for(i=1;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendImage/W=Display_graph $Displaywave_y
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		LegendText = w_dir[0]
		Legend/C/J/A=MB/X=30/Y=80/N=Legend0 LegendText
	else
		//___Default
		LegendText = w_dir[0]
		Legend/C/J/A=MB/X=30/Y=80/N=Legend0 LegendText
	endif
end

//___Kinetic
Function Displayoption_13() 
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	NVAR doFit = root:Kinetic_doFit
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText,w_fit,Displaywave_fit,Kinetics,Fitwave_coef
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={0,bottom}
			ModifyGraph noLabel($axis)=1,tick(axis0)=3
		endfor
		ModifyGraph margin(left)=34

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18\f02R\Bt\M\Z18/R\B0\f00"
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
		endfor
		ModifyGraph margin(left)=59,mode=2,lsize=2

		SetAxis Left *,*
		Label Left "\Z18\f02R\Bt\M\Z18/R\B0\f00"
	endif

	//__about axies
	ModifyGraph tick=2,mirror=1,minor=1
	Label bottom "\Z18\f02time\f00/ s"

	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,1/(V_max-V_min)}
		endfor
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,1-V_max}
		endfor
	endif

	//___doFit
	Kinetics = "root:'Kinetics'"
	make/O/N=(Counter) $Kinetics
	Wave w_k = $Kinetics

	if(doFit == 1)
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"

			w_fit = ReplaceString("_ywave",w_y[i],"_fit_ywave")
			Displaywave_fit = "root:'"+w_dir[i]+"':'"+w_fit+"'"
			make/O/N=(Dimsize($Displaywave_y,0)) $Displaywave_fit

			make/O/N=3 $("root:'"+w_dir[i]+"':'Wave_coef'")

			CurveFit exp_XOffset kwCWave=$("root:'"+w_dir[i]+"':'Wave_coef'") $Displaywave_y /X=$Displaywave_x /D=$Displaywave_fit
			AppendtoGraph/W=Display_graph/C=(65535,0,0) $Displaywave_fit vs $DisplayWave_x

			Fitwave_coef = 	"root:'"+w_dir[i]+"':'Wave_coef'"
			Wave w_coef = $Fitwave_coef
			w_k[i] = 1/w_coef[2]
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

//___Bandstructure calc
Function Displayoption_9()  

    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i,k,Line_x,Kpoint_text
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,Displaywave_x_text,w_x,w_x_text,axis_left,axis_bottom
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,630,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis_left = "axis"+num2str(i)+"_left"
			axis_bottom = "axis"+num2str(i)+"_bottom"
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			w_x_text = w_x + "_text"
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			DisplayWave_x_text = "root:'"+w_dir[i]+"':'"+w_x_text+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"

			for(k=0;k<DimSize($Displaywave_y,1);k++)
				AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/B=$axis_bottom/L=$axis_left $Displaywave_y[][k] vs $DisplayWave_x
			endfor
			
			SetAxis $axis_left -1,6
			ModifyGraph axisEnab($axis_bottom)={i/Counter,((i+1)/Counter-0.075)},freePos($axis_bottom)={0,kwFraction},freePos($axis_left)={i/Counter,kwFraction}
			ModifyGraph tick($axis_left)=1,minor($axis_left)=1,mirror($axis_bottom)=1,tick($axis_bottom)=3
			ModifyGraph userticks($axis_bottom)={$DisplayWave_x,$DisplayWave_x_text}
			ModifyGraph margin(left)=42,margin(right)=2

			SetDrawEnv textxjust= 1,textyjust= 1,textrot= 0,xcoord=$axis_bottom
			DrawText 0.5,1.1,"\Z18\f02k"
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18Relative Energy / eV"
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			w_x_text = w_x + "_text"
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			DisplayWave_x_text = "root:'"+w_dir[i]+"':'"+w_x_text+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"

			for(k=0;k<DimSize($Displaywave_y,1);k++)
				AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y[][k] vs $DisplayWave_x
			endfor
		endfor
		ModifyGraph mode=4,marker=19
		ModifyGraph tick(left)=1,minor(left)=1,mirror(bottom)=1,tick(bottom)=3
		ModifyGraph userticks(bottom)={$DisplayWave_x,$DisplayWave_x_text}
		ModifyGraph margin(left)=42,margin(right)=28

		SetAxis Left -1,3
		Label Left "\Z18Relative Energy / eV"
		Label bottom "\Z18kpoint"
	endif

	//___draw kpoint
	if(check2 == 1)
		for(i=0;i<Counter;i++)
			axis_bottom = "axis"+num2str(i)+"_bottom"
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			w_x_text = w_x + "_text"
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			DisplayWave_x_text = "root:'"+w_dir[i]+"':'"+w_x_text+"'"

			wave/T w_kpoint_text = $Displaywave_x_text
			wave w_kpoint_value = $Displaywave_x
			SetDrawEnv xcoord=$axis_bottom,save

			for(k=0;k<DimSize(w_kpoint_value,0);k++)
				Kpoint_text = strlen(w_kpoint_text[k])
				if(Kpoint_text != 0)
					Line_x = w_kpoint_value[k]
					DrawLine Line_x,0,Line_x,1
					print "debug"
				endif
			endfor
		endfor
	else
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			w_x_text = w_x + "_text"
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			DisplayWave_x_text = "root:'"+w_dir[i]+"':'"+w_x_text+"'"

			wave/T w_kpoint_text = $Displaywave_x_text
			wave w_kpoint_value = $Displaywave_x
			SetDrawEnv xcoord=bottom,save

			for(k=0;k<DimSize(w_kpoint_value,0);k++)
				Kpoint_text = strlen(w_kpoint_text[k])
				if(Kpoint_text != 0)
					Line_x = w_kpoint_value[k]
					DrawLine Line_x,0,Line_x,1
				endif
			endfor
		endfor
	endif
end

// calc voigt covolution
Function Displayoption_10()  
    
    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	// if(check2 == 1)
	// 	//___Tile Verticaly
	// 	for(i=0;i<Counter;i++)
	// 		axis = "axis"+num2str(i)
	// 		w_x = ReplaceString("_ywave",w_y[i],"_xwave")
	// 		DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
	// 		Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
	// 		AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
	// 		ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={0,bottom}
	// 		ModifyGraph noLabel($axis)=1,tick(axis0)=3
	// 		ModifyGraph margin(left)=34
	// 	endfor

	// 	SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
	// 	DrawText -0.05,0.5,"\Z18\f02Current\f00 / A"
	// else
		//___Default
	// 	for(i=0;i<Counter;i++)
	// 		w_x = ReplaceString("_ywave",w_y[i],"_xwave")
	// 		DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
	// 		Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
	// 		AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
	// 	endfor

	// 	SetAxis Left *,*
	// 	Label Left "\Z18\f02Current\f00 / A"
	// 	ModifyGraph margin(left)=59
	// endif

	//__about axies
	// ModifyGraph tick=2,mirror=1,minor=1
	// Label bottom "\Z18\f02Voltage\f00 / V"

	//___normalize
	// if(check0 == 1)
	// 	for(i=0;i<Counter;i++)
	// 		Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
	// 		WaveStats/Q $Displaywave_y
	// 		Modifygraph muloffset($w_y[i])={0,1/V_max}
	// 	endfor
	// endif

	//___offset
	// if(check1 == 1)
	// 	for(i=0;i<Counter;i++)
	// 		Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
	// 		WaveStats/Q $Displaywave_y
	// 		Modifygraph offset($w_y[i])={0,-V_min}
	// 	endfor
	// endif

	//___legend
	// if(check2 == 1)
	// 	LegendText = ""
	// 	//___Tile Verticaly
	// 	for(i=0;i<Counter;i++)
	// 		LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
	// 		axis = "axis"+num2str(i)
	// 		SetDrawEnv ycoord = $axis,textxjust=1
	// 		DrawText 0.8,0.8,LegendText
	// 	endfor
	// else
	// 	//___Default
	// 	LegendText = "\Z23"
	// 	for(i=0;i<Counter-1;i++)
	// 		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
	// 	endfor
	// 	LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
	// 	Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	// endif

	Displayoption_voigt(0.2, 0.2, 0.2)
end

Function Displayoption_voigt(variable gauwidth, variable lorwidth, variable lorwidth_energy)

    variable i,j,k
	NVAR Counter = root:Counter
	Wave/T w = root:LoadFiles_wave
	variable Num_of_Elements
	make/N=(Counter)/D/O Num_of_eigenvalues

	variable eigenvalue_max, eigenvalue_min
	variable ga0, lo0

	for(i=0;i<Counter;i++)
		// eigenvalue のmax, min取得
		wavestats $(w[i]+"_ywave")

		if(i==0)
			eigenvalue_max = V_max
			eigenvalue_min = V_min
		endif
		if(i!=0)
			if(eigenvalue_max < V_max)
				eigenvalue_max = V_max
			endif
			if(eigenvalue_min > V_min)
				eigenvalue_min = V_min
			endif
		endif
		
		Num_of_eigenvalues[i] = Dimsize($(w[i]+"_ywave"),0)
	endfor

	// wave $("BE")を作成
	// // 畳み込み積分区間: [eigenvalue_min - 10, eigenvalue_max + 10]; 刻み幅: 0.01
	Num_of_Elements = 1 + ceil(((eigenvalue_max + 10) - (eigenvalue_min - 10)) * 100)
	// BE軸設定  最小値: round(V_min * 100) / 100 - 10; 刻み幅: 0.01
	make/N = (Num_of_Elements)/D/O BE
	setscale/P x (round(V_min * 100) / 100 - 10), 0.01, BE
	BE = x

	// wave $("weight"), $("point"), $("gau"), $("lor")を作成
	for(i=0;i<Counter;i++)
		make/N=(Num_of_Elements)/D/O $(w[i]+"_weight")
		wave weight=$(w[i]+"_weight")
		wave eigenvalues=$(w[i]+"_ywave")
		weight = 0

		for(j=0;j<Num_of_Elements;j++)
			for(k=0;k<Dimsize(eigenvalues,0);k++)
				if(round(100*BE[j]) == round(100*eigenvalues[k]))
					weight[j] += 1
				endif
			endfor
		endfor

		make/N=(Num_of_eigenvalues[i])/D/O $(w[i]+"_point")
		wave point = $(w[i]+"_point")
		point=0

		make/N=(Num_of_elements)/D/O $(w[i]+"_gau")
		make/N=(Num_of_elements)/D/O $(w[i]+"_lor")
		wave gau = $(w[i]+"_gau")
		wave lor = $(w[i]+"_lor")

		// --------------gaussian convolution--------------
		gauwidth = gauwidth / 2

		for(j=0;j<Num_of_Elements;j++)
			ga0=0
			for(k=0;k<Num_of_Elements;k++)
				ga0 += weight[k] * (1 / (2.50663 * gauwidth)) * (exp(- (BE[j] - BE[k]) * (BE[j] - BE[k]) / (2 * gauwidth * gauwidth)))
			endfor
			gau[j]=ga0
		endfor

		// --------------lorentzian convolution--------------
		lorwidth = lorwidth / 2
		for(j=0;j<Num_of_Elements;j++)
			lo0=0
			for(k = 0; k < Num_of_Elements; k++)
        		lo0 += gau[k] * ((lorwidth + lorwidth_energy * BE[k]) * (lorwidth + lorwidth_energy * BE[k])) / (((BE[j] - BE[k]) * (BE[j] - BE[k])) + ((lorwidth + lorwidth_energy * BE[k]) * (lorwidth + lorwidth_energy * BE[k])))
        	endfor
			lor[j]=lo0
		endfor
	endfor 
end

//___AFM
Function Displayoption_12()  

    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i,Z_min,Z_max
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,DisplayWave_img,DisplayWave_hist,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_image
	dowindow/F Display_image
	Display/W=(30,30,630,630)/N=Display_image

	if(Counter >= 2)
		Newmovie/O/F=2/Z/CF=1
	endif
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			w_x = ReplaceString("_ywave",w_y[i],"_img")
			DisplayWave_img = "root:'"+w_dir[i]+"':'"+w_x+"'"
			w_x = ReplaceString("_ywave",w_y[i],"_hist_ywave")
			DisplayWave_hist = "root:'"+w_dir[i]+"':'"+w_x+"'"

			AppendImage/W=Display_image $DisplayWave_img vs {$DisplayWave_x,$DisplayWave_y}
			w_x = ReplaceString("_ywave",w_y[i],"_img")
			DisplayWave_img = w_x
			if(i == 0)
				wavestats/Q $Displaywave_img
				Z_min = V_min
				Z_max = V_max
			endif
			ModifyImage $DisplayWave_img ctab= {Z_min,Z_max,Gold,0}

			Label bottom "\Z23\\$WMTEX$ \\mu \\$/WMTEX$m"
    		Label left "\Z23\\$WMTEX$ \\mu \\$/WMTEX$m"
    		ModifyGraph minor(bottom)=1,sep=10,axisEnab(bottom)={0,0.7},mirror(bottom)=1
			ModifyGraph minor(left)=1,sep=10
			ModifyGraph margin(right)=0,margin(top)=28,height={Plan,1,left,bottom}

			ColorScale/C/N=colorscale/A=LB/F=0 image=$DisplayWave_img,prescaleExp=-3,minor=1,lblMargin=60,heightPct=107
    		ColorScale/C/N=colorscale/X=75/Y=10/E=2/F=0 "\Z18\\$WMTEX$ \\mu \\$/WMTEX$m"

        	AddMovieframe
        	doupdate/W=Display_image/E=1
		endfor
	else
		//___Default
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			w_x = ReplaceString("_ywave",w_y[i],"_img")
			DisplayWave_img = "root:'"+w_dir[i]+"':'"+w_x+"'"
			w_x = ReplaceString("_ywave",w_y[i],"_hist_ywave")
			DisplayWave_hist = "root:'"+w_dir[i]+"':'"+w_x+"'"

			AppendImage/W=Display_image $DisplayWave_img vs {$DisplayWave_x,$DisplayWave_y}

			w_x = ReplaceString("_ywave",w_y[i],"_img")
			DisplayWave_img = w_x
			ModifyImage $DisplayWave_img ctab= {*,*,Gold,0}
			AppendtoGraph/W=Display_image/L=$("hist_left")/B=$("hist_bottom")/VERT $DisplayWave_hist
		endfor
	endif

	//__about axies
    Label bottom "\Z23\\$WMTEX$ \\mu \\$/WMTEX$m"
    Label left "\Z23\\$WMTEX$ \\mu \\$/WMTEX$m"
    ModifyGraph minor(bottom)=1,sep=10,axisEnab(bottom)={0,0.7},mirror(bottom)=1
    ModifyGraph minor(left)=1,sep=10
    ModifyGraph axisEnab($("hist_left"))={0,1},freePos($("hist_left"))={0,hist_bottom},noLabel(hist_left)=1,axThick($("hist_left"))=0
    ModifyGraph minor($("hist_bottom"))=1,sep($("hist_bottom"))=10,axisEnab($("hist_bottom"))={0.9,1.0}
    ModifyGraph freePos($("hist_bottom"))=0,tick($("hist_bottom"))=2, lblPos($("hist_bottom"))=30
    ModifyGraph margin(right)=0,margin(top)=28,height={Plan,1,left,bottom}

	//___about colorscale
    ColorScale/C/N=colorscale/A=LB/F=0 image=$DisplayWave_img,prescaleExp=-3,minor=1,lblMargin=60,heightPct=107
    ColorScale/C/N=colorscale/X=75/Y=10/E=2/F=0 "\Z18\\$WMTEX$ \\mu \\$/WMTEX$m"

	//___legend
	TextBox/C/N=text0/F=0/A=LB/E=2/X=10.75/Y=96.25 DisplayWave_img

	closemovie
end

Function Displayoption_EXP_6()  

    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={0,bottom}
			ModifyGraph noLabel($axis)=1,tick(axis0)=3
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18Intensity / arb. units"
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
		endfor

		SetAxis Left *,*
		Label Left "\Z18Intensity / arb. units"
	endif

	//__about axies
	ModifyGraph tick=2,mirror=1,minor=1
	Label bottom "\Z18Wavelength / nm"

	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,1/V_max}
		endfor
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

Function Displayoption_EXP_7()  

    NVAR Counter = root:Counter
	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
	variable i
	Wave w_rgb = root:rgb
    String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

	//___display raw data
	dowindow/K Display_graph
	dowindow/F Display_graph
	Display/W=(30,30,430,430)/N=Display_graph
	
	ColorGeneretor(Counter)
	if(check2 == 1)
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			axis = "axis"+num2str(i)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={0,bottom}
			ModifyGraph noLabel($axis)=1,tick(axis0)=3
		endfor

		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
		DrawText -0.05,0.5,"\Z18Intensity / arb. units"
	else
		//___Default
		for(i=0;i<Counter;i++)
			w_x = ReplaceString("_ywave",w_y[i],"_xwave")
			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
		endfor

		SetAxis Left *,*
		Label Left "\Z18Intensity / arb. units"
	endif

	//__about axies
	ModifyGraph tick=2,mirror=1,minor=1
	Label bottom "\Z18Wavelength / nm"

	//___normalize
	if(check0 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph muloffset($w_y[i])={0,1/V_max}
		endfor
	endif

	//___offset
	if(check1 == 1)
		for(i=0;i<Counter;i++)
			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
			WaveStats/Q $Displaywave_y
			Modifygraph offset($w_y[i])={0,-V_min}
		endfor
	endif

	//___legend
	if(check2 == 1)
		LegendText = ""
		//___Tile Verticaly
		for(i=0;i<Counter;i++)
			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
			axis = "axis"+num2str(i)
			SetDrawEnv ycoord = $axis,textxjust=1
			DrawText 0.8,0.8,LegendText
		endfor
	else
		//___Default
		LegendText = "\Z23"
		for(i=0;i<Counter-1;i++)
			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
		endfor
		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
	endif
end

// CELIV
// Function Displayoption_19()  

//     NVAR Counter = root:Counter
// 	NVAR check0 = root:Display_check0,check1 = root:Display_check1,check2 = root:Display_check2
// 	variable i
// 	Wave w_rgb = root:rgb
//     String DisplayWave_x,Displaywave_y,w_x,axis,LegendText
// 	Wave/T w_y = root:Display_List,w_dir = root:Display_dir

// 	//___display raw data
// 	dowindow/K Display_graph
// 	dowindow/F Display_graph
// 	Display/W=(30,30,430,430)/N=Display_graph
	
// 	ColorGeneretor(Counter)
// 	if(check2 == 1)
// 		//___Tile Verticaly
// 		for(i=0;i<Counter;i++)
// 			axis = "axis"+num2str(i)
// 			if(Stringmatch(w_y[i],"*_ch1_ywave")==1)
// 				w_x = ReplaceString("_ch1_ywave",w_y[i],"_xwave")
// 			elseif(Stringmatch(w_y[i],"*_ch2_ywave")==1)
// 				w_x = ReplaceString("_ch2_ywave",w_y[i],"_xwave")
// 			endif
// 			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
// 			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
// 			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2])/L=$axis $Displaywave_y vs $DisplayWave_x
			
// 			ModifyGraph axisEnab($axis)={i/Counter,(i+1)/Counter},freePos($axis)={0,bottom}
// 			ModifyGraph noLabel($axis)=1,tick(axis0)=3
// 			ModifyGraph margin(left)=34
// 		endfor

// 		SetDrawEnv textxjust= 1,textyjust= 1,textrot= 90
// 		DrawText -0.05,0.5,"\Z18\f02Current\f00 / A"
// 	else
// 		//___Default
// 		for(i=0;i<Counter;i++)
// 			if(Stringmatch(w_y[i],"*_ch1_ywave")==1)
// 				w_x = ReplaceString("_ch1_ywave",w_y[i],"_xwave")
// 			elseif(Stringmatch(w_y[i],"*_ch2_ywave")==1)
// 				w_x = ReplaceString("_ch2_ywave",w_y[i],"_xwave")
// 			endif
// 			DisplayWave_x = "root:'"+w_dir[i]+"':'"+w_x+"'"
// 			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
// 			AppendtoGraph/W=Display_graph/C=(w_rgb[i][0],w_rgb[i][1],w_rgb[i][2]) $Displaywave_y vs $DisplayWave_x
// 		endfor

// 		SetAxis Left *,*
// 		Label Left "\Z18\f02Current\f00 / A"
// 		ModifyGraph margin(left)=59
// 	endif

// 	//__about axies
// 	ModifyGraph tick=2,mirror=1,minor=1
// 	Label bottom "\Z18\f02Voltage\f00 / V"

// 	//___normalize
// 	if(check0 == 1)
// 		for(i=0;i<Counter;i++)
// 			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
// 			WaveStats/Q $Displaywave_y
// 			Modifygraph muloffset($w_y[i])={0,1/V_max}
// 		endfor
// 	endif

// 	//___offset
// 	if(check1 == 1)
// 		for(i=0;i<Counter;i++)
// 			Displaywave_y = "root:'"+w_dir[i]+"':'"+w_y[i]+"'"
// 			WaveStats/Q $Displaywave_y
// 			Modifygraph offset($w_y[i])={0,-V_min}
// 		endfor
// 	endif

// 	//___legend
// 	if(check2 == 1)
// 		LegendText = ""
// 		//___Tile Verticaly
// 		for(i=0;i<Counter;i++)
// 			LegendText = "\Z20"+ReplaceString("_ywave",w_y[i],"")
// 			axis = "axis"+num2str(i)
// 			SetDrawEnv ycoord = $axis,textxjust=1
// 			DrawText 0.8,0.8,LegendText
// 		endfor
// 	else
// 		//___Default
// 		LegendText = "\Z23"
// 		for(i=0;i<Counter-1;i++)
// 			LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")+"\r"
// 		endfor
// 		LegendText += "\s('"+w_y[i]+"') "+ReplaceString("_ywave",w_y[i],"")
// 		Legend/C/J/A=MB/X=20.00/Y=70.00/N=Legend0 LegendText
// 	endif
// end
$(document).ready(function() {
    window.ResourceName = 'FMGangs'
    let closeKeys = [ 27];
    let GangInofPageOpen = 'nogang'
    let GangSelectedInCreatedCODE = 0
    let GanginfoSelected = 0
    let PCColdDown = false 
   
    let timerint = setInterval(function() {
        let strTime = new Date().toLocaleTimeString();
        const date = new Date(); 
        const year = date.getFullYear(); 
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0'); 
        $("#TIME").html(strTime + `<img src="img/clock.png">`) 
        $("#TODAY").html(year + '.' + month +  '.' + day + `<img src="img/day.png">`) 
    }, 1000)
    window.addEventListener("keyup", (e) => {
        if (closeKeys.includes(e.keyCode)) {
            CloseAdminPanel()
        }
    })
    function OpenBossSectionPanel(Name , Rank , Profile  , GangName ) {
        $("#ADMINNAME").text(Name);
        $("#ADMINRANK").text(Rank);
        $('#ADMINPHOTO').attr("src", Profile )
        $(".CGLeftButton").hide();
        $(".CGRightTopGangs").hide();
        OpenAdminPanelGangCreatePage(true , GangName )
        $(".CGCGOptionbutton").hide();  
        $("#CGGANG").show();  
        $(".CGCGOptionbutton").removeClass('CGCGButtonSelected'); 
        $("#CGGANG").addClass('CGCGButtonSelected'); 
        $("#CREATEGANGLABELINPUT").prop("disabled", true); 
        $("#CREATEGANGEXPIREINPUT").prop("disabled", true); 

        $("#CREATEGANGLOGOINPUT").prop("disabled", true); 
        $("#CREATEGANGWEBHOOKINPUT").prop("disabled", true); 
        $("#CREATEFGANG").hide();  
        $("#CGMain").fadeIn(400);

    }
    function OpenAdminPanel(Name , Rank , Profile ) {
        $("#ADMINNAME").text(Name);
        $("#ADMINRANK").text(Rank);
        $(".CGLeftButton").show();
        $(".CGRightTopGangs").show();
        $("#CREATEGANGLABELINPUT").prop("disabled", false); 
        $("#CREATEGANGEXPIREINPUT").prop("disabled", false); 
        $("#CREATEGANGLOGOINPUT").prop("disabled", false); 
        $("#CREATEGANGWEBHOOKINPUT").prop("disabled", false); 
        $("#CREATEFGANG").show();  
        $('#ADMINPHOTO').attr("src", Profile )
        OpenAdminPanelHomePage();
        $("#CGMain").fadeIn(400);
    }
    function CloseAdminPanel() {
        $.post('http://'+ window.ResourceName  + '/CLOSEADMINPANEL', JSON.stringify({})  );
        $("#CGMain").fadeOut();
        CloseAllAdminPanelPages();
    }
    function CloseAllAdminPanelPages() {
        $("#HOMEPAGE").hide();
        $("#GANGSPAGE").hide();
        $("#SHOWGANGINFOPAGE").hide();
        $("#CREATEGANG").hide();
        $("#PACKSPAGE").hide();
    }   
    function OpenAdminPanelHomePage() {
        $.post('https://'+ window.ResourceName  + '/HOMEDATA', JSON.stringify({}), function( HomeInfo  ) { 
            $("#ALLCREATED").text( HomeInfo.Count + ' CREATED');
            $("#CREATEDLINEVALUE").css( 'width' , HomeInfo.Count+'%')
            if (HomeInfo.Count > 100 ) { 
                $("#CREATEDLINEVALUE").css( 'width' , '100%')
            }
            // ONLINE
            $("#ONLINEMEMBERS").text( HomeInfo.Online + ' MEMBERS'); 
            $("#ONLINELINEVALUE").css( 'width' ,  (( HomeInfo.Online / HomeInfo.All ) * 100).toFixed(2)+'%')
            // OFFLINE 
            $("#OFFLINEMEMBERS").text( HomeInfo.Offline + ' MEMBERS');  
            $("#OFFLINELINEVALUE").css( 'width' , (( HomeInfo.Offline / HomeInfo.All ) * 100).toFixed(2) +'%')
            $("#HOMEPAGEGANGBADGE").hide()
            $("#HOMEGANGPLAYERLIST").html('')
            $("#RIGHTTOPGANGS").html('')  
            if (HomeInfo.Count > 0  ) {
                HomePageUpdateGang(HomeInfo.TopGang ,HomeInfo.MaxXP  ,HomeInfo.AllMembers  , HomeInfo.TopGangs )
            }
            //                  
            CloseAllAdminPanelPages();
            $("#HOMEPAGE").fadeIn(1000);
        }); 
   
    }
    function HomePageUpdateGang (TopGang , MaxXP , AllMembers , TopGangs  ) {
        $("#HOMEPAGEGANGBADGE").hide()
        // NAME 
        $("#HOMEGANGNAME").text(TopGang.Name );   
        //  MEMBERS ONLINE
        let AllTGM =  Object.keys( AllMembers[ TopGang.Name  ]['offline']).length +  Object.keys( AllMembers[ TopGang.Name ]['online']).length
        $("#HOMEGANGMEMBERLINE").css( 'width' , (Object.keys( AllMembers[ TopGang.Name  ]['online']).length / AllTGM  * 100).toFixed(2) + '%')
        // EXPIRE
        $("#HOMEGANGEXPIRELINE").css( 'width' ,TopGang.ExpirationDP +  '%') 
        ///  LEVEL 
        $("#HOMEGANGLEVELTEXT").text(TopGang.Level + '/10');   
        $("#HOMEGANGLEVELLINE").css( 'width' , TopGang.Level * 10 +'%')
        ///  XP
        $('#BADGELOGOGANGHOME').attr("src", TopGang.logo ) 
        $("#HOMEGANGXPTEXT").text(TopGang.XP +'/' + MaxXP[TopGang.Level]);   
        $("#HOMEGANGXPLINE").css( 'width' , ((TopGang.XP / MaxXP[TopGang.Level]) * 100).toFixed(2) +'%')
        $("#HOMEGANGPLAYERLIST").html('')
        $("#RIGHTTOPGANGS").html('')  
        $("#HOMEPAGEGANGBADGE").show()
        // 
        let pCount = 0
        
        for (const key in AllMembers[TopGang.Name]['online']) { 
            pCount  =  pCount + 1 
            $("#HOMEGANGPLAYERLIST").prepend(GetHomePagePlayerListHTML(AllMembers[TopGang.Name]['online'][key]['Name'] , AllMembers[TopGang.Name]['online'][key]['Grade'] , AllMembers[TopGang.Name]['online'][key]['Hex'] , pCount , 1 , AllMembers[TopGang.Name]['online'][key]['Avatar']  ) )
           
          } 
          for (const key in AllMembers[TopGang.Name]['offline']) { 
            pCount  =  pCount + 1 
            $("#HOMEGANGPLAYERLIST").prepend(GetHomePagePlayerListHTML(AllMembers[TopGang.Name]['offline'][key]['Name'] , AllMembers[TopGang.Name]['offline'][key]['Grade'] , AllMembers[TopGang.Name]['offline'][key]['Hex'] , pCount , 0 , AllMembers[TopGang.Name]['offline'][key]['Avatar']  ) )
           
          } 
          $("#COPYUSERSTEAM").click(function () {
            copyToClipboard($("#USERHOMESTEAM").text())
        });  
      // TOP RIGHT GANG  
     
        if ( TopGangs[4] )  {
            $("#RIGHTTOPGANGS").prepend(GetHomeRightTopGangsHTML(TopGangs[4]['Name'], TopGangs[4]['Level'] , TopGangs[4]['XP'] , Object.keys( AllMembers[TopGangs[4]['Name']]['online']).length +   Object.keys( AllMembers[TopGangs[4]['Name']]['offline']).length , 5 , TopGangs[4]['logo']   ))  
        }
        if ( TopGangs[3] )  {
            $("#RIGHTTOPGANGS").prepend(GetHomeRightTopGangsHTML(TopGangs[3]['Name'], TopGangs[3]['Level'] , TopGangs[3]['XP'] , Object.keys( AllMembers[TopGangs[3]['Name']]['online']).length +   Object.keys( AllMembers[TopGangs[3]['Name']]['offline']).length , 4 , TopGangs[3]['logo']   ))  
        }
        if ( TopGangs[2] )  {
            $("#RIGHTTOPGANGS").prepend(GetHomeRightTopGangsHTML(TopGangs[2]['Name'], TopGangs[2]['Level'] , TopGangs[2]['XP'] , Object.keys( AllMembers[TopGangs[2]['Name']]['online']).length +   Object.keys( AllMembers[TopGangs[2]['Name']]['offline']).length , 3 , TopGangs[2]['logo']   ))  
        }
        if ( TopGangs[1] )  {
            $("#RIGHTTOPGANGS").prepend(GetHomeRightTopGangsHTML(TopGangs[1]['Name'], TopGangs[1]['Level'] , TopGangs[1]['XP'] , Object.keys( AllMembers[TopGangs[1]['Name']]['online']).length +   Object.keys( AllMembers[TopGangs[1]['Name']]['offline']).length , 2 , TopGangs[1]['logo']   ))  
        }
        if ( TopGangs[0] )  {
            $("#RIGHTTOPGANGS").prepend(GetHomeRightTopGangsHTML(TopGangs[0]['Name'], TopGangs[0]['Level'] , TopGangs[0]['XP'] , Object.keys( AllMembers[TopGangs[0]['Name']]['online']).length +   Object.keys( AllMembers[TopGangs[0]['Name']]['offline']).length , 1 , TopGangs[0]['logo']   ))  
        }
      
      
       
    }
    function GetHomeRightTopGangsHTML(Name, LeveL , XP  , Members  , key , logo  ) {
      
        let boder = {
            [1] : "#FFFF00", 
            [2] : "#ffffff", 
            [3] : "#F28627", 
            [4] : "#2757F2", 
            [5] : "#2757F2", 
        }
        let Html = `
       	<div class="CGTopGang" style="border-right-color:`+boder[key]+` ;"  >
            <img src= `+ logo +`>
            <div class="point" style="width: 3px; height: 3px; position: relative; left: 39px; bottom: 19px; background : 00000000"></div>
            <span class="CGTopGangName"> `+Name +`</span>
            <div class="point" style="width: 3px;height: 3px;position: relative;left: 85px;bottom: 45px;background-color: #00FFF2;"></div>
            <div class="point" style="width: 3px;height: 3px;position: relative;left: 85px;bottom: 41px;background-color: #FF0000;"></div>
            <div class="point" style="width: 3px;height: 3px;position: relative;left: 85px;bottom: 37px;background-color: #FFFF00;"></div>
            <span class="CGTopGangMembers">Members : ` + Members+` </span>
            <span class="CGTopGangLeveL">LeveL : `+ LeveL+`</span>
            <span class="CGTopGangXP">XP : `+XP+`</span>
        </div>
        `
        return Html
    }
    function GetHomePagePlayerListHTML(Name, Rank , Steam  , Count ,line , Avatar  ) {
        let linecolor  = {
            [0] : 'red',
            [1] : '#00FF4C',
        }
        let Html = `
            <div class="CGMLGang">
                <span class="CGMLGCount">#`+ Count + `</span>
                <img src=`+ Avatar + `>
                <span class="point" style="width: 6px;height: 6px;display: inline-block;background-color: `+ linecolor[line] + `;position: relative	;margin-left: 30px;top: -2px;"></span>
                <span class="CGMLGName ">`+Name +`</span>
                <span class="CGMLGGrade">`+ Rank +`</span>
                <span class="CGMLGSteam" id = USERHOMESTEAM>`+ Steam + `</span>
                <i class="fas fa-clone" style="color: #054283 ;font-size: 9px;margin-left: 12px;position: relative;top: -2px;cursor: pointer;" id = COPYUSERSTEAM></i>
            </div>
        `
        return Html
    }
    function GetGangsPageGangListHTML( Name ,Pic, Memberp , Expirep  , LevelP , Level  , Xpp , XP) {
        let Html = `
	<div class="CGMGLGang" id = `+Name+` >	
        <div class="CGMGLGName">`+Name+`</div> 
        <img src="`+Pic+`">
        <div class="CGMGLGInfoText">Members</div>
        <div class="CGMGLGInfoTextLine"><div class="CGMGLGInfoTextLineValue" style="width: `+Memberp+`%;"></div></div>
        <div class="CGMGLGInfoText">Expire</div>
        <div class="CGMGLGInfoTextLine"><div class="CGMGLGInfoTextLineValue" style="width: `+Expirep+`%;"></div></div>
        <div class="CGMGLGInfoText" style="margin-top: 9px;">LEVEL</div>
        <div class="CGMGLGInfoTextLine" style="width: 158px; margin-bottom: 3px;">	<div class="CGMGLGInfoTextLineValue"  style="width: `+LevelP+`%;"></div> </div>
        <div class="CMGLGITLVText" >`+Level+`</div>
        <div class="CGMGLGInfoText" style="margin-top: -13px;">XP</div>
        <div class="CGMGLGInfoTextLine"style="width: 158px;"><div class="CGMGLGInfoTextLineValue"style="width: `+Xpp+`%;"></div></div>
        <div class="CMGLGITLVText" >`+XP+`</div>		
    </div>	
        `
        return Html
    }
    function OpenAdminPanelGangsPage() {
        CloseAllAdminPanelPages()
        $("#GANGSPAGELIST").html('')
           ///  List 
           $("#GANGSEARCHNAME").val('') 
        $.post('https://'+ window.ResourceName  + '/GANGSDATA', JSON.stringify({}), function( data  ) { 
            let Gangs = data.Gangs
            for (const key in Gangs) { 
                if ( key != 'nogang') {
                    let AllMembers = data.AllMembers
                    let AllTGM =  Object.keys( AllMembers[ key  ]['offline']).length +  Object.keys( AllMembers[ key ]['online'] ).length 
                    let percentOfMembers = (Object.keys( AllMembers[ key  ]['online']).length / AllTGM  * 100).toFixed(2)  ;
                    $("#GANGSPAGELIST").prepend(GetGangsPageGangListHTML(key , Gangs[key]['logo'] , percentOfMembers , data.Expires[key] , Gangs[key]['level'] * 10  , Gangs[key]['level']+'/10', ((  Gangs[key]['xp']/ data.Levels[Gangs[key]['level']] ) * 100).toFixed(2) , Gangs[key]['xp']+'/' + data.Levels[Gangs[key]['level']] ) )
                }
            }
            
            $(".CGMGLGang").click(function () {
                OpenAdminPanelGangInfoPage(this.id)
            }); 
            $("#GANGSPAGE").fadeIn(500);
        }); 
        /// Open Page
      
    }
    function OpenAdminPanelGangInfoPage(GANGNAME) {
        GanginfoSelected = GanginfoSelected + 1 
        let ThisGangPage = GanginfoSelected
        GangInofPageOpen = GANGNAME
        CloseAllAdminPanelPages();
        $("#INFOGANGPLAYERLIST").html('')
        /// NAME
        $.post('https://'+ window.ResourceName  + '/GETGANG', JSON.stringify({ gang : GANGNAME }), function( data  ) { 
            $("#INFOGANGNAME").html(GANGNAME + `  <button class="CGMSGIDeletebutton">DELETE</button>`);
            ///  LEVEL
            $("#INFOGANGLEVELTEXT").text( data.Gang.level +'/10');   
            $("#INFOGANGLEVEL").css( 'width' ,  data.Gang.level * 10 +'%')
            ///  XP 
            $("#INFOGANGXPLEVEL").text( data.Gang.xp +'/' + data.Levels[data.Gang.level ] );   
            $("#INFOGANGXP").css( 'width' , ((  data.Gang['xp']/ data.Levels[data.Gang.level ] ) * 100).toFixed(2) +'%')
            /// Expire
            $("#INFOGANGEXPIRELEVEL").text( data.Expire + '%');   
            $("#INFOGANGEXPIRE").css( 'width' , data.Expire + '%')
            /// MEMBERS
            let AllMembers = data.Members
            let AllTGM =  Object.keys( AllMembers['offline']).length +  Object.keys( AllMembers['online'] ).length 
            let percentOfMembers = (Object.keys( AllMembers['online']).length / AllTGM  * 100).toFixed(2)  ;
            $("#INFOGANGMEMBERSTEXT").text( Object.keys( AllMembers['online'] ).length  + '/' + AllTGM );   
            $("#INFOGANGMEMBERS").css( 'width' , percentOfMembers + '%')
            /// SLOT 
            $("#INFOGANGSLOTTEXT").text( AllTGM + '/' + data.Gang.others['slot'] );   
            $("#INFOGANGSLOT").css( 'width' ,( AllTGM / data.Gang.others['slot']   * 100).toFixed(2) + '%')
            ///  ARMOUR
            $("#INFOGANGARMOURTEXT").text( data.Gang.others['armor'] + '/100');   
            $("#INFOGANGARMOUR").css( 'width' ,  data.Gang.others['armor'] + '%')
            // Players disband
            let pCount = 0
            
            if (data.Gang.disband === 0 ) {
                $("#INFOGANGDISBAND").text( 'DISBAND'); 
                $("#INFOGANGDISBAND").css('background' ,'linear-gradient(90deg, #242626 0%, #FF0000 100%)'  )
    
            }
             else  {
                $("#INFOGANGDISBAND").text('ACTIVE'); 
                $("#INFOGANGDISBAND").css('background' ,'linear-gradient(90deg, #242626 0%, #27f238 100%)'  )
                
       
             }
            for (const key in AllMembers['online']) { 
                pCount  =  pCount + 1 
                $("#INFOGANGPLAYERLIST").prepend(AdminPanelGangInfoPagePlayersHTML(pCount ,  AllMembers['online'][key].Avatar, AllMembers['online'][key]['Name'] ,  AllMembers['online'][key]['Grade'] ,AllMembers['online'][key]['Hex'] , 1) )
            
              } 
              for (const key in AllMembers['offline']) { 
                pCount  =  pCount + 1 
                $("#INFOGANGPLAYERLIST").prepend(AdminPanelGangInfoPagePlayersHTML(pCount ,  AllMembers['offline'][key].Avatar, AllMembers['offline'][key]['Name'] ,  AllMembers['offline'][key]['Grade'] ,AllMembers['offline'][key]['Hex'] , 0) )
            
              } 
              $("#COPYGANGSUSERSTAEM").click(function () {
                copyToClipboard($("#GANGSUSERSTAEM").text())
            });  
           //
            $('#INFOGANGPIC').attr("src",data.Gang.logo )
         
            $(".CGMSGIDeletebutton").click(function () {
                if( ThisGangPage != GanginfoSelected ) return 
                $.post('https://'+ window.ResourceName  + '/DELETEGANG', JSON.stringify({ gang_name : GANGNAME }), function(  Delete ) { 
                    CloseAdminPanel()  
                if (Delete === true ) {
                        
                    }
                    else 
                    {
                       // OpenAdminPanelGangInfoPage(GANGNAME)
                    }
                }); 
              
            }); 
            $("#INFOGANGDISBAND").click(function () {
                if( ThisGangPage != GanginfoSelected ) return 

                $.post('https://'+ window.ResourceName  + '/DISBANDGANG', JSON.stringify({ gang_name : GANGNAME }), function(  DISBAND ) { 
                    OpenAdminPanelGangInfoPage(GANGNAME) 
                }); 
              
            });
            $("#INFOGANGTELEPORT").click(function () {
                if( ThisGangPage != GanginfoSelected ) return 
                CloseAdminPanel()
                $.post('https://'+ window.ResourceName  + '/TELEPORT', JSON.stringify({ gang_name : GANGNAME }), function(  DISBAND ) { 
                    
                }); 
              
            });
            $("#SHOWGANGINFOPAGE").fadeIn(1000);
        }); 
        //
       
    }
    function AdminPanelGangInfoPagePlayersHTML(count ,pic , Name , rank , Steam ,   ONLINE   ) {
        let color = {
            [0] : '#ff0000', 
            [1] : '#00FF4C', 
        }
    let Html = `	
        <div class="CGMSGIGangMember" >
            <span class="CGMSGICount">#`+count +`</span>
            <img src= `+pic+`>
            <span class="point" style="width: 6px;height: 6px;display: inline-block;background-color: `+ color[ONLINE] + `;position: relative	;margin-left: 93px;top: -2px;"></span>
            <span class="CGMSGIName "> `+Name+`  </span>
            <span class="CGMSGIGrade">`+rank+`</span>
            <span class="CGMSGISteam" id = GANGSUSERSTAEM >`+Steam+`</span>
            <i class="fas fa-clone" style="color: #2757F2;font-size: 13px;margin-left: 125px;position: relative;top: -2px;cursor: pointer;" id = COPYGANGSUSERSTAEM ></i>
        </div>
     `
        return Html
    }

    function OpenAdminPanelGangCreatePage(Upgrade , GangName ) {
        CloseAllAdminPanelPages()
        $("#CREATEGANGNAMEINPUT").val('') 
        $("#CREATEGANGLABELINPUT").val('') 
        $("#CREATEGANGEXPIREINPUT").val('')
        $("#CREATEGANGLOGOINPUT").val('') 
        $("#CREATEGANGWEBHOOKINPUT").val('') 
        if (Upgrade) {
            $(".CGCGOptionbutton").show(); 
            $("#CREATEGANGRANK").show(); 
            $("#CREATEFGANG").text('UPDATE')
            $("#CREATEFGANG").show();     
            $("#CREATEGANGNAMEINPUT").prop("disabled", true); 
            $(".CGCGOptionbutton").removeClass('CGCGButtonSelected'); 
            $("#CGGANG").addClass('CGCGButtonSelected'); 
            $(".CGCGCGRADDRankMenu").hide(); 
            AdminPanelCreateGangOpenOption('CGGANG', true  , GangName ) 
        }
        else {
            $(".CGCGCGRADDRankMenu").hide(); 
            $(".CGCGOptionbutton").hide();   
            $("#CGGANG").show(); 
            $("#CREATEGANGRANK").hide();
            $("#CREATEGANGNAMEINPUT").prop("disabled", false); 
            $("#CREATEFGANG").text('CREATE')   
            $("#CREATEFGANG").show();  
            $(".CGCGOptionbutton").removeClass('CGCGButtonSelected'); 
            $("#CGGANG").addClass('CGCGButtonSelected'); 
            AdminPanelCreateGangOpenOption('CGGANG' , false )          
        }
        $(".CGCGOptionbutton").click(function () {
            $(".CGCGCGRADDRankMenu").hide(); 
            $(".CGCGOptionbutton").removeClass('CGCGButtonSelected'); 
            $('#'+this.id).addClass('CGCGButtonSelected'); 
            AdminPanelCreateGangOpenOption(this.id , Upgrade , GangName ) 
        });
        $("#CREATEGANG").fadeIn(1000);
    }
    function AdminPanelCreateGangOpenOption(Option , Upgrade , GangName ) {
        GangSelectedInCreatedCODE = GangSelectedInCreatedCODE + 1
        let ThisFunctionCode = GangSelectedInCreatedCODE
        
        $("#CGGANGPAGE").hide();    
        $("#CGOPTIONS").hide();
        $("#OTHERSPAGE").hide();   
        $("#RANKLISTINUPDATEGANG").html('')
        $('#GANGLOGOINUPDATEPAGE').attr("src","img/playerpic.png")
        if (Option == 'CGGANG') { 
            $("#CGGANGPAGE").fadeIn(50); 
            if (Upgrade) {
                $.post('https://'+ window.ResourceName  + '/UPGRADEGANGINFO', JSON.stringify({ gang_name : GangName }), function( data  ) { 
                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                    $("#CREATEGANGNAMEINPUT").val(data.name) 
                    $("#CREATEGANGLABELINPUT").val(data.label) 
                    $("#CREATEGANGEXPIREINPUT").val(data.expire_day)
                    $("#CREATEGANGLOGOINPUT").val(data.logo) 
                    $("#CREATEGANGWEBHOOKINPUT").val(data.webhook) 
                    $('#GANGLOGOINUPDATEPAGE').attr("src", data.logo ) 
                    $("#RANKLISTINUPDATEGANG").html('')

                    for (const key in data.grades ) { 

                        $("#RANKLISTINUPDATEGANG").prepend(AdminPanelAddRanks(data.grades[key].grade , data.grades[key].name  , data.grades[key].label   )) 
                    } 
                    let NewGradeData = {}
                    let keyofstart = 1 
                    for (const key in data.grades ) { 
                        NewGradeData[keyofstart] = data.grades[key]
                        keyofstart = keyofstart + 1
                    } 

                    let EditRank = 0
                    data.grades = NewGradeData
                    $(".CGCGCGEditRank").click(function () { 
                        if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                        EditRank = this.id
     
                        $("#GRADEINPUTLABEL").val( data.grades[EditRank].name )
                        $("#GRADEINPUTNAME").val( data.grades[EditRank].label )
                        $("#GRADEINPUTSALARY").val(data.grades[EditRank].salary  )
                        $("#CGADDRANK").text('EDIT');
                        $(".CGCGCGARMBody").css('height' , '330px')
                        $(".CGCGCGARMBAccess").show(); 
                        $(".CGCGCGARMBAccsesList").show(); 
                        for (const key in data.grades[EditRank].access) { 
               
                            if ( data.grades[EditRank].access[key] === true ) {
                                $('#'+key ).addClass('SetAccesSelected'); 
                                $('#'+key+'r' ).removeClass('SetAccesSelected'); 
                            }
                            else {
                                $('#'+key+'r' ).addClass('SetAccesSelected'); 
                                $('#'+key ).removeClass('SetAccesSelected');
                            }
                        } 
                        for (const key in data.grades[EditRank].access) { 
                        
                            $("#"+ key ) .click(function () {
                                if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                          
                                $.post('http://'+ window.ResourceName  + '/EDITACCESS', JSON.stringify({ gang_name : data.name , grade : EditRank, access: key , value : true ,  }), function( statuts  ) { 
                                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                                    if ( statuts === true ) {
                                        $('#'+key ).addClass('SetAccesSelected'); 
                                        $('#'+key+'r' ).removeClass('SetAccesSelected'); 
                                    }
                                    else {
                                        $('#'+key+'r' ).addClass('SetAccesSelected'); 
                                        $('#'+key ).removeClass('SetAccesSelected');
                                    }
                               
                                })
                            })
                            $("#"+ key +'r') .click(function () {
                                if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                                $.post('http://'+ window.ResourceName  + '/EDITACCESS', JSON.stringify({ gang_name : data.name , grade : EditRank, access: key , value : false ,  }), function( statuts  ) { 
                                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                                    if ( statuts === true ) {
                                        $('#'+key ).addClass('SetAccesSelected'); 
                                        $('#'+key+'r' ).removeClass('SetAccesSelected'); 
                                    }
                                    else {
                                        $('#'+key+'r' ).addClass('SetAccesSelected'); 
                                        $('#'+key ).removeClass('SetAccesSelected');
                                    }
                               
                                })
                            })
                        } 
                        $(".CGCGCGRADDRankMenu").show(); 
                 
                    }); 
                  
                    $("#CGADDRANK").click(function () {
                        if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                        $(".CGCGCGRADDRankMenu").hide(); 
                      
                        if ( $("#CGADDRANK").text() === 'EDIT') {
                         
                            let label = $("#GRADEINPUTLABEL").val()
                            let name = $("#GRADEINPUTNAME").val()
                            let salary = $("#GRADEINPUTSALARY").val()
                            $.post('http://'+ window.ResourceName  + '/EDITRANK', JSON.stringify({ gang_name : data.name , grade : EditRank, name : name ,label : label ,salary:salary  }), function( dataeidt  ) { 
                                EditRank = 0 
                                AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                            })
                        } 
                        else {
                            let label = $("#GRADEINPUTLABEL").val()
                            let name = $("#GRADEINPUTNAME").val()
                            let salary = $("#GRADEINPUTSALARY").val()
                            $.post('http://'+ window.ResourceName  + '/ADDRANK', JSON.stringify({ gang_name : data.name , name : name ,label : label , salary:salary }), function( dataeidt  ) {                        
                                AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                            })
                        }
                    }); 
                    $(".CGCGCGDeleteRank").click(function () { 
                        if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                        $.post('http://'+ window.ResourceName  + '/DELETERANK',  JSON.stringify({ gang_name : data.name , grade : this.id , }) , function( datadelete  ) { 
                            AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                        })
                
                    }); 

                }); 
            }
        }
        else if (Option == 'others') {
            $(".OthersBtn2").removeClass('othersSelected')
            $(".OthersBtn3").removeClass('othersSelected')
            $.post('http://'+ window.ResourceName  + '/GETOTHERS', JSON.stringify({ gang_name : GangName  ,  }), function( data  ) {    
                if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                if (data.gps === 0 ) {
                    $("#gps .OthersBtn2").addClass('othersSelected')
                    $("#gps .OthersBtn3").removeClass('othersSelected')
                }  
                else {
                    $("#gps .OthersBtn2").removeClass('othersSelected')
                    $("#gps .OthersBtn3").addClass('othersSelected')
                }        
                if (data.basealaram === 0 ) {
                    $("#basealaram .OthersBtn2").addClass('othersSelected')
                    $("#basealaram .OthersBtn3").removeClass('othersSelected')
                }  
                else {
                    $("#basealaram .OthersBtn2").removeClass('othersSelected')
                    $("#basealaram .OthersBtn3").addClass('othersSelected')
                }   
                if (data.cuff === 0 ) {
                    $("#cuff .OthersBtn2").addClass('othersSelected')
                    $("#cuff .OthersBtn3").removeClass('othersSelected')
                }  
                else {
                    $("#cuff .OthersBtn2").removeClass('othersSelected')
                    $("#cuff .OthersBtn3").addClass('othersSelected')
                }  
                if (data.search === 0 ) {
                    $("#search .OthersBtn2").addClass('othersSelected')
                    $("#search .OthersBtn3").removeClass('othersSelected')
                }  
                else {
                    $("#search .OthersBtn2").removeClass('othersSelected')
                    $("#search .OthersBtn3").addClass('othersSelected')
                }   
                if (data.lockpick === 0 ) {
                    $("#lockpick .OthersBtn2").addClass('othersSelected')
                    $("#lockpick .OthersBtn3").removeClass('othersSelected')
                }  
                else {
                    $("#lockpick .OthersBtn2").removeClass('othersSelected')
                    $("#lockpick .OthersBtn3").addClass('othersSelected')
                } 
                $("#armor .CGCGOthersinput").val(data.armor)
                $("#slot .CGCGOthersinput").val(data.slot)
                $("#clothe .CGCGOthersinput").val(data.clothe)
                $(".OthersBtn").click(function () { 
                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                    let val = $("#"+ this.id + " .CGCGOthersinput").val()
                    $.post('http://'+ window.ResourceName  + '/SAVEOTHERS', JSON.stringify({ gang_name : GangName  , option : this.id , value : val }), function(   ) {    
                        AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                    })
                });
                $(".OthersBtn2").click(function () { 
                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return              
                    $.post('http://'+ window.ResourceName  + '/SAVEOTHERS', JSON.stringify({ gang_name : GangName  , option : this.id , value : 0 }), function(   ) {    
                        AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                    })
                });
                $(".OthersBtn3").click(function () { 
                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                    $.post('http://'+ window.ResourceName  + '/SAVEOTHERS', JSON.stringify({ gang_name : GangName  , option : this.id , value : 1 }), function(   ) {    
                        AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                    })
                });
                $("#OTHERSPAGE").fadeIn(500);                          
            })
      
   
        }
        else  {
            if (Upgrade) {
                $("#CREATEGANGOPTIONLIST").html('')
                $.post('https://'+ window.ResourceName  + '/UPGRADEOPTIONS', JSON.stringify({ gang_name : GangName  , option : Option }), function( data  ) { 
                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                    for (const key in data) { 
                        
                        $("#CREATEGANGOPTIONLIST").prepend(CreateGangOptionMarkerListHTML(data[key].type +' | '+data[key].marker , key   ))
                    } 
                 
                    $(".CGCGACOEdit").click(function () { 
                        if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                            CloseAdminPanel()
                        $.post('https://'+ window.ResourceName  + '/EDITMARKER', JSON.stringify({ gang_name : GangName  , option : Option , code :data[this.id].code  , AllData : data[this.id]  }), function() { 
                            AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                        }); 
                    });
                    $(".CGCGACODelete").click(function () { 
                        if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                        $.post('https://'+ window.ResourceName  + '/DELETEMARKER', JSON.stringify({ gang_name : GangName  , option : Option , code :data[this.id].code , AllData : data[this.id]   }), function() { 
                            AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                        }); 
                    });
                    $(".CGCGACOCoord").click(function () { 
                        if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                        CloseAdminPanel()
                        $.post('https://'+ window.ResourceName  + '/TELEPORTMARKER', JSON.stringify({ gang_name : GangName  , option : Option ,  code :data[this.id].code , AllData : data[this.id]  }), function() { 
                        //    AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                        }); 
                    });
                }); 
            }
            let type  = 'marker'
            let Selected = 0
            let color = { r : 255 , g : 0 , b : 0 }
            if ( Option === 'blip' || Option === 'flag') {
                type = Option ;
                color = 1;
                $("#MARKERIMAGE").css('width' , '100px') ;
                $("#MARKERIMAGE").css('height' , '100px') ;
                $("#MARKERIMAGE").css('left' , '75.5px') ;
                $("#MARKERIMAGE").css('top' , '79px') ;
                $(".CGCGColorofMarkerinput").hide()
              
            }
            else {
                $("#MARKERIMAGE").css('width' , '120px') ;
                $("#MARKERIMAGE").css('height' , '180px') ;
                $("#MARKERIMAGE").css('left' , '62.5px') ;
                $("#MARKERIMAGE").css('top' , '44px') ;
                $(".CGCGColorofMarkerinput").show()
            }
            $("#MARKERIMAGE").css('filter' , 'drop-shadow(rgba(255, 0, 0, 0.68) 0px 5px 10px)')
            $.post('https://'+ window.ResourceName  + '/GETOPTIONSDATA', JSON.stringify({option : Option }), function( data  ) { 
                if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return          
                $('#MARKERIMAGE').attr("src",  'img/'+ type+ '/'+ data[type][Selected] + '.png'  ) 
                $("#MARKERLEFT").click(function () { 
                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                    if ( Selected - 1 <= 0 ) {
                        Selected = Object.keys(data[type]).length - 1
                    }
                    else {
                        Selected = Selected - 1 
                    }
                    $('#MARKERIMAGE').attr("src",  'img/'+ type+ '/'+ data[type][Selected] + '.png'  ) 
                }); 
                $("#MARKERRIGHT").click(function () { 
                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                    if ( Selected + 1 >=  Object.keys(data[type]).length  ) {
                        Selected = 0
                    }
                    else {
                        Selected = Selected + 1 
                    }
                   
                    $('#MARKERIMAGE').attr("src",  'img/'+ type+ '/'+ data[type][Selected] + '.png'  ) 
                });
                $(".CGCGCPBbutton").click(function () { 
                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
    
                    if( this.id != 'ADDGANGMARKER') {
                        if (Option != 'blip'  || Option === 'flag' ) 
                        type  = this.id
                        Selected = 1
                        $('#MARKERIMAGE').attr("src",  'img/'+ type+ '/'+ data[type][Selected] + '.png'  ) 
                    }
                });
                $("#WHITE").on('input', function() { 
                    const colorInput = document.getElementById('WHITE'); 
                        const colorValue = colorInput.value; 
                        const r = parseInt(colorValue.slice(1, 3), 16); 
                        const g = parseInt(colorValue.slice(3, 5), 16); 
                        const b = parseInt(colorValue.slice(5, 7), 16); 
                        color = { r : r , g : g , b : b }
                        $("#MARKERIMAGE").css('filter' , 'drop-shadow(rgba('+r+','+g+','+b+', 0.68) 0px 5px 10px)')
                        if ( Option === 'blip') {
                            color = 0;
                        }
                  }); 
                $(".CGCGColorofMarker").click(function () { 
                    if (this.id === 'RED') {
                        color = { r : 255 , g : 0 , b : 0 }
                        $("#MARKERIMAGE").css('filter' , 'drop-shadow(rgba(255, 0, 0, 0.68) 0px 5px 10px)')
                        if ( Option === 'blip') {
                            color = 1;
                        }
                    }
                    else if (this.id === 'GREEN') {
                        color = { r : 0 , g : 255 , b : 0 }
                        $("#MARKERIMAGE").css('filter' , 'drop-shadow(rgba(0, 255, 0, 0.68) 0px 5px 10px)')
                        if ( Option === 'blip') {
                            color = 2;
                        }
                    }
                    else if (this.id === 'BLUE') {
                        color = { r : 0 , g : 204 , b : 255 }
                        $("#MARKERIMAGE").css('filter' , 'drop-shadow(rgba(0, 204, 255, 0.68) 0px 5px 10px)')
                        if ( Option === 'blip') {
                            color = 38;
                        }
                    }
                 
                });
                $("#ADDGANGMARKER").click(function () { 
                    if ( ThisFunctionCode !=  GangSelectedInCreatedCODE) return 
                    CloseAdminPanel()            
                    $.post('https://'+ window.ResourceName  + '/ADDOPTIONS', JSON.stringify({ gang_name : GangName  , option : Option , type : type , marker : data[type][Selected] , size : { x :  $("#MARKERX").val() , y :  $("#MARKERY").val() , z :  $("#MARKERZ").val()} , colour : color  }), function() { }); 
                    if (Option === 'blip')  {
                        AdminPanelCreateGangOpenOption(Option , Upgrade , GangName )
                    }
                }); 
            }); // CGCGCPBbutton
            $(".CGCGLeftInfoText").text($("#"+Option).text());
            $("#CGOPTIONS").fadeIn(1000); 
           
          
        }

    }
    function CreateGangOptionMarkerListHTML(coord , key ) {
        let html = `
        	<div class="CGCGACOption">
                <div class="CGCGACOEdit" id = `+key+` ></div>
                <div class="CGCGACODelete" id = `+key+` ></div>
                <div class="CGCGACOCoord" id = `+key+`><div class ='CGCGACOCoordText' >`+coord+`</div></div>
            </div>
            `
        return html
    }
    function AdminPanelAddRanks(Grade , NAME , label  )  {
        let html = `
        	<div class="CGCGCGRank" id = `+ Grade+ `>
                <div class="CGCGCGEditRank" id = `+ Grade+ `></div>
                <div class="CGCGCGDeleteRank" id = `+ Grade+ `></div>
                <div class="CGCGCGInfoRank">
                    <div class="CGCGCGIRText" style="margin-left: 19px;">#`+ Grade+ `</div>
                    <div class="CGCGCGIRText"id = 'GRADELISTNAME'  style="margin-left: 7px;">`+ NAME+ `</div>
                    <div class="CGCGCGIRText"id = 'GRADELISTLABEL'  style="margin-left: 20px;">`+ label+ `</div>
                 
                </div>
            </div>
        `
        return html
    }
    //////////////////////
    $("#CREATEFGANG").click(function () {
        if ($("#CREATEFGANG").text() === 'UPDATE') {
            let gangdata = {} 
            gangdata['gang_name'] = $("#CREATEGANGNAMEINPUT").val() 
            gangdata['label'] = $("#CREATEGANGLABELINPUT").val() 
            gangdata['expire'] = $("#CREATEGANGEXPIREINPUT").val()
            gangdata['logo'] = $("#CREATEGANGLOGOINPUT").val()
            gangdata['webhook'] = $("#CREATEGANGWEBHOOKINPUT").val()
            $.post('https://'+ window.ResourceName  + '/UPDATEGANG', JSON.stringify(gangdata ), function( ) { 
                OpenAdminPanelGangCreatePage(true , $("#CREATEGANGNAMEINPUT").val() )
            }); 
        }
        else {
            let gangdata = {} 
            gangdata['name'] = $("#CREATEGANGNAMEINPUT").val() 
            gangdata['label'] = $("#CREATEGANGLABELINPUT").val() 
            gangdata['expire'] = $("#CREATEGANGEXPIREINPUT").val()
            gangdata['logo'] = $("#CREATEGANGLOGOINPUT").val()
            gangdata['webhook'] = $("#CREATEGANGWEBHOOKINPUT").val()
            $.post('https://'+ window.ResourceName  + '/CREATEGANG', JSON.stringify(gangdata ), function( data  ) { 
                if (data.Created === true) {
                    OpenAdminPanelGangCreatePage(true , gangdata['name'])
                }
                else {
                    OpenAdminPanelGangCreatePage(false)
                }
             
            }); 
        }
   
    }); 
  
    $("#CREATEGANGRANK").click(function () {
        $("#GRADEINPUTLABEL").val( '' )
        $("#GRADEINPUTNAME").val( '')
        $("#GRADEINPUTSALARY").val( '')
        $("#CGADDRANK").text('ADD'); 
        $(".CGCGCGARMBody").css('height' , '205px')
        $(".CGCGCGARMBAccsesList").hide(); 
        $("#CGCGCGARMBAccess").hide(); 
        $(".CGCGCGRADDRankMenu").show(); 
    });
    $("#CGCLOSEMENURANK").click(function () {
        $(".CGCGCGRADDRankMenu").hide(); 
    }); 
    $("#CGCLOSEMENURANK").click(function () {
        $(".CGCGCGRADDRankMenu").hide(); 
    });  
 
    $("#GOHOMEPAGE").click(function () {
        if (  PCColdDown  ) return 
        PCColdDown = true 
        setTimeout(() => {
            PCColdDown = false 
        }, 1000);
        OpenAdminPanelHomePage() 

    }); 
    $("#GOGANGSPAGE").click(function () {
        if (  PCColdDown  ) return 
        PCColdDown = true 
        setTimeout(() => {
            PCColdDown = false 
        }, 1000);
        OpenAdminPanelGangsPage()
       
    }); 
    $("#GOCREATEGANGSPAGE").click(function () {
        if (  PCColdDown  ) return 
        PCColdDown = true 
        setTimeout(() => {
            PCColdDown = false 
        }, 1000);
        OpenAdminPanelGangCreatePage(false)
     
    });  
    $("#GOPACKSPAGE").click(function () {
        PCColdDown = true 
        setTimeout(() => {
            PCColdDown = false 
        }, 1000);
        CloseAllAdminPanelPages()
        $("#PACKSPAGE").fadeIn(1000);
     
    }); //       
    $(".CGMPbutton").click(function () {
       let GangName = $("#" +this.id + 'input').val() 
       let pack = this.id 
       $(".CGMPInput").val( '')
       $.post('http://'+ window.ResourceName  + '/GIVEPACK', JSON.stringify({ pack  : pack , gang_name : GangName})  );
       CloseAllAdminPanelPages()
       $("#PACKSPAGE").fadeIn(1000);
   
    });
    $("#CLOSEADMINPAGE").click(function () {
        CloseAdminPanel()
    });
    $("#INFOGANGUPGRADE").click(function () {
        OpenAdminPanelGangCreatePage(true , GangInofPageOpen )
    }); 

    $("#INFOGANGTELEPORT").click(function () {
        CloseAdminPanel()
    }); 
 $("#SREACHBUTTOM").click(function () {
        $("#GANGSPAGELIST").html('')
        $.post('https://'+ window.ResourceName  + '/GANGSDATA', JSON.stringify({}), function( data  ) { 
            let Gang = data.Gangs[$("#GANGSEARCHNAME").val()]   
            if ( Gang != null ) { 
            let Gangs = {}
            Gangs[$("#GANGSEARCHNAME").val()] = Gang 
            for (const key in Gangs) { 
                if ( key != 'nogang') {
                    let AllMembers = data.AllMembers
                    let AllTGM =  Object.keys( AllMembers[ key  ]['offline']).length +  Object.keys( AllMembers[ key ]['online'] ).length 
                    let percentOfMembers = (Object.keys( AllMembers[ key  ]['online']).length / AllTGM  * 100).toFixed(2)  ;
                    $("#GANGSPAGELIST").prepend(GetGangsPageGangListHTML(key , Gangs[key]['logo'] , percentOfMembers , data.Expires[key] , Gangs[key]['level'] * 10  , Gangs[key]['level']+'/10', ((  Gangs[key]['xp']/ data.Levels[Gangs[key]['level']] ) * 100).toFixed(2) , Gangs[key]['xp']+'/' + data.Levels[Gangs[key]['level']] ) )
                }
            }
            $(".CGMGLGang").click(function () {
                OpenAdminPanelGangInfoPage(this.id)
            }); 
            }
        }); 
    }); 
     /// 
     function copyToClipboard(textToCopy) { 
       
        const tempInput = document.createElement('input'); 
        tempInput.value = textToCopy; 
        document.body.appendChild(tempInput); 

        tempInput.select(); 

        document.execCommand("copy"); 

        document.body.removeChild(tempInput); 

        console.log("Copied to clipboard:", textToCopy); 
      } 
    
   window.addEventListener('message', (event) => { 
        if (event.data.type == 'OPENADMINPANEL') {
            OpenAdminPanel(event.data.Admin.Name , event.data.Admin.Rank , event.data.Admin.Profile )
        }
        else  if (event.data.type == 'OPENBOSSPANEL') {
            OpenBossSectionPanel(event.data.Admin.Name , event.data.Admin.Rank , event.data.Admin.Profile  ,event.data.GangName ) 
        }
    })
})    
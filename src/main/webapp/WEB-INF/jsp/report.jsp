<!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
    <%@page import="sas.bean.Question"%>
    <%@page import="sas.bean.Answer"%>
    <%@ page import="java.util.*" %>
    <head>
        

      <script>
        var userSession = {};
      </script>
      <%
        String webContext = "";
        String userid = (String) request.getAttribute("userid");
		String lang = (String) request.getAttribute("language");
        /* begin: assuming below inputs are coming from report link from pdf */
        Hashtable<String, String> hLabels = (Hashtable<String, String>) request.getAttribute("labels");  
         String planHeaderDesc = hLabels.get("plan_header_desc");
         String doHeaderDesc = hLabels.get("do_header_desc");
         String checkHeaderDesc = hLabels.get("check_header_desc");
         String firstParaHeading = hLabels.get("pdf_first_para_heading");
         String firstParagraph1 = hLabels.get("pdf_first_paragraph1");
         String firstParagraph2 = hLabels.get("pdf_first_paragraph2");
         String firstParagraph3 = hLabels.get("pdf_first_paragraph3");
         String firstParagraph4 = hLabels.get("pdf_first_paragraph4");
         String lastParaHeading = hLabels.get("pdf_last_para_heading");
         String lastParagraph1 = hLabels.get("pdf_last_paragraph1");
         String lastParagraph2 = hLabels.get("pdf_last_paragraph2");
         String lastParagraph3 = hLabels.get("pdf_last_paragraph3");
         String imageClickDesc =  hLabels.get("image_click_description");
         String secName1 = hLabels.get("secName1");
         String secName2 = hLabels.get("secName2");
         String secName3 = hLabels.get("secName3");
         String actionlabel = hLabels.get("actionlabel");
         String youScoredLabel = hLabels.get("youscoredlabel");
         String spiderLegend1 = "Your travel risk management self-assessment results";
         String spiderLegend2 = "Industry benchmark";
         if(hLabels.containsKey("spider_legend_1")) spiderLegend1 = hLabels.get("spider_legend_1") ;
         if(hLabels.containsKey("spider_legend_2")) spiderLegend2 = hLabels.get("spider_legend_2") ;
        if(request.getAttribute("userdata") != null) {

            %>
                <script>
                    var planSection = {}, doSection = {}, checkSection = {}, allSections = {}, surPro = {}, fullD = {},
                        surveyProgress = {'plan': {}, 'do': {}, 'check': {}}, fullData = {};
            <%
                    List<String> userList = (List<String>) request.getAttribute("userdata");
                    for(int i=0; i < userList.size(); i++) {
                        %>
                        userSession["f1"] = "<%= userList.get(i) %>";
                        userSession["f2"] = "<%= userList.get(++i) %>";
                        userSession["f4"] = "<%= userList.get(++i) %>";
                        <%
                    }

                    Hashtable<String, String> ans = (Hashtable<String, String>) request.getAttribute("answers");
					 
                    Set<String> ansKeys = ans.keySet();
                    for(String key: ansKeys) {
                        %>
                            surPro['<%=key%>'] = '<%= ans.get(key) %>';
                        <%
                    }
                    
                    
                    Hashtable<String, List<Question>> hs = (Hashtable<String, List<Question>>) request.getAttribute("questions");  
                    List<Question> list = hs.get("plan");
                    int totalQuestions = 0;
                    Question q = null;
                    for(int i=0; i < list.size(); i++) {
                        q = list.get(i);
            %>
                        planSection["<%= q.getId() %>"] =  {
                            "qry" : "<%= q.getText() %>",
                            "subsection" : "<%= q.getSubtype() %>",
                            "description": "<%= q.getDesc() %>",
                            "img" : "<%= q.getImageName() %>",
                            "val" : surPro['<%= q.getId() %>']
                        };
                        surveyProgress['plan']["<%= q.getId() %>"] = surPro['<%= q.getId() %>'];
            <%
                    }
            %>
                    allSections["plan"] = planSection;
            <%
                    list = hs.get("do");
                    q = null;
                    System.out.println(list.size());
                    for(int i=0; i < list.size(); i++) {
                        q = list.get(i);
            %>
                        doSection["<%= q.getId() %>"] =  {
                            "qry" : "<%= q.getText() %>",
                            "subsection" : "<%= q.getSubtype() %>",
                            "description": "<%= q.getDesc() %>",
                            "img" : "<%= q.getImageName() %>",
                            "val" : surPro['<%= q.getId() %>']
                        };
                        surveyProgress['do']["<%= q.getId() %>"] = surPro['<%= q.getId() %>'];
            <%
                    }
            %>        
                    allSections["do"] = doSection;
            <%
                    list = hs.get("check");
                    q = null;
                    System.out.println(list.size());
                    for(int i=0; i < list.size(); i++) {
                        q = list.get(i);
            %>
                        checkSection["<%= q.getId() %>"] =  {
                            "qry" : "<%= q.getText() %>",
                            "subsection" : "<%= q.getSubtype() %>",
                            "description": "<%= q.getDesc() %>",
                            "img" : "<%= q.getImageName() %>",
                            "val" : surPro['<%= q.getId() %>']
                        };
                        surveyProgress['check']["<%= q.getId() %>"] = surPro['<%= q.getId() %>'];
            <%
                    }
            %>
                    allSections["check"] = checkSection;
                    userSession['surveyProgress'] = surveyProgress;
                    userSession['fullData'] = allSections;
                    userSession.finished = true;
                </script>
            <%
                    //System.out.println("Total Question : " + totalQuestions);               
            
        } else {
            %>
                <script>
                userSession = JSON.parse(localStorage.getItem("userInfo"));
                </script>
            <%
        }

        
        /* end: assuming above inputs are coming from report link from pdf */


      %>
      <script>
        
        var surveyProgress = {},
        answers = {}, responseAvg = {};
        <%
        System.out.println(request.getAttribute("responseavg"));
        if(request.getAttribute("responseavg") != null) {
        	Hashtable<String, List<String>> reshs = (Hashtable<String, List<String>>) request.getAttribute("responseavg");
            //List<String> resAvgList = new ArrayList<String>();
            for(String resKey : reshs.keySet()) {
            	List<String> resAvgList = reshs.get(resKey);
            	 for(int i=0; i < resAvgList.size(); i++) {
            	%>
            		responseAvg["<%=resKey %>"] = {
            			"yesAvg" : "<%= resAvgList.get(i) %>",
            			"noAvg" : "<%= resAvgList.get(++i) %>",
            			"notSureAvg" : "<%= resAvgList.get(++i) %>"
            		};
            	<%
            	 }
            }
        }
        %>
        if(!!userSession && !!userSession.f4) {
          //user session is still alive, let's move-on.

          surveyProgress = !!userSession.fullData ? userSession.fullData : {};
          if(!!userSession.finished) {
            //TODO: let's continue to show report page.
            <%
              String scoreLable = "You scored ";
            %>
                answers = !!userSession.surveyProgress ? userSession.surveyProgress : {};
          } else {
            document.location.href = "survey";
          }
        } else {
          //user session got expired. let's re-direct to home page.
          document.location.href = "home";
        }

      </script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Report Page</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/x-icon"/>
<link href="<%=webContext%>support/lib/bootstrap.min.css"
	rel="stylesheet">
<link href="<%=webContext%>support/lib/chart/radar-chart.min.css"
	rel="stylesheet">
<link href="<%=webContext%>support/css/site.css" rel="stylesheet">

<script type="text/javascript" async=""
	src="<%=webContext%>support/js/ga.js"></script>
<script src="<%=webContext%>/support/lib/jquery-3.2.0.js"></script>
<script src="<%=webContext%>support/lib/bootstrap.min.js"></script>
<script src="<%=webContext%>support/lib/chart/d3.v3.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/canvg/1.4/rgbcolor.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stackblur-canvas/1.4.1/stackblur.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/canvg/dist/browser/canvg.min.js"></script>
<!-- <script type="text/javascript" src="//canvg.googlecode.com/svn/trunk/rgbcolor.js"></script>  -->
<!-- <script type="text/javascript" src="//canvg.googlecode.com/svn/trunk/canvg.js"></script> -->
<script src="<%=webContext%>support/lib/chart/radar-chart.min.js"></script>
<script type="text/javascript" async=""
	src="<%=webContext%>support/js/assessment.js"></script>
</head>

<body>
	<form name="reportForm" method="post" action="post" id="reportForm">
		<input type="hidden" id="score1" name="score1" value="42" /> <input
			type="hidden" id="username1" name="username1" value="scas" />
		<div class="container">
			<div id="outer" class="row">
				<div id="header"
					class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div id="logo" class="pull-right"></div>
				</div>
				<div id="content_wrap"
					class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">
						<div id="results" style="">
							<div class="results-header">
								<img class="cover-width" src="./support/img/result_header.png"
									alt="Sections"> <a id="btnPrintPDF" href="/print"
									target="_blank" onClick="javascript:updateA();"></a>
							</div>
							<div class="content">
								<div class="results_h2_wrap stripe">
									<h2><%=youScoredLabel%>
										<span id="score"></span>%
									</h2>
								</div>
								<div class="results_padding">
									<div id="graph" class="action_needed1">
										<img class="cover-width action-consider" id="sos-graph" src=""
											alt="Action Consider">
									</div>

                      <script>
						function updateA() {
                            if($("#btnPrintPDF").attr("href").indexOf("?scoreinfo") === -1) {
							    $("#btnPrintPDF").attr("href", $("#btnPrintPDF").attr("href")+"?pdfFilePath=" + $("#pdfFilePath").val());
                            }
						}
                        $(document).ready(function () {
                        	//debugger;
                        	var totalQuestions = 0,
                              totalYes = 0,
                              totalNo = 0,
                              totalNotsure = 0,
                                    subSec = {}
                              generateForm = function (sectionName){
                                var qNum = 0;

                                $.each(surveyProgress[sectionName], function(qid) {
                                    if(subSec[this.subsection] === undefined) {
                                        subSec[this.subsection] = [];
                                    }

                                    var showQuestion = this.val;
                                    if(showQuestion === undefined) {
                                      showQuestion = answers[this.currentSection][this.qid].val;
                                    }
                                    subSec[this.subsection].push(showQuestion);
                                });
                                $.each(surveyProgress[sectionName], function(qid) {
                                  qNum++;
                                  var showQuestion = this.val;
                                  if(showQuestion === undefined) {
                                      showQuestion = answers[this.currentSection][this.qid].val;
                                  }
                                  
                                  if(showQuestion === 'yes') {
                                      totalYes++;
                                  }
                                  if(showQuestion === 'no') {
                                      totalNo++;
                                  }
                                  if(showQuestion === 'notsure') {
                                      totalNotsure++;
                                  }
                                  //if(showQuestion !== 'yes') {
                                    var tmpl = $('.question_template').clone(true);
                                    tmpl.find('.question_id').id = qid;
                                    tmpl.find('.question_number')[0].innerText = "Q" + qNum;
                                    tmpl.find('.question_text')[0].innerText = this.qry;
                                    tmpl.find('.question_desc')[0].innerText = this.description;
                                    tmpl.show();
                                    $("." + sectionName + "_section")[0].appendChild(tmpl[0]);
                                  //}
                                });
                                totalQuestions += qNum;
                                if(qNum > 0) {
                                  $("#" + sectionName).show();
                                }
                              };
                          generateForm('plan');
                          generateForm('do');
                          generateForm('check');
                          var scoreData = [], indusStandards = [], chartData = [], questionData = [], responseAvgData=[],blueColorQuestions = [];
                          var qcount = 1;
                          var isColorBlue = false;
                          $.each(subSec, function(ss) {
                        	  	//console.log(subSec + " :" + ss + " count :" + this.length);
                                var totalCount = Number(this.length),
                                	spotOnQ=Math.floor(parseFloat(Number(qcount)+(Number(totalCount)/2))),
                                    totalYesCount = this.filter(function(value){
                                        return value === 'yes';
                                    }).length,
                                    perCalValue = (totalYesCount * 100) / totalCount,
                                    calValue = perCalValue / 100,
                                    //calValue2 = ((calValue.toFixed(2)) + '').replace('.00', '') + '%',
                                    //titleVal = ss + ' (' + calValue + ')';
                                	/* for(qcount; qcount<=(qcount+totalCount);qcount++) {
                                		if(qcount==spotOnQ) {
                                			
                                			scoreData.push(obj);
                                		} else {
                                			obj = {
                                                    axis: "Q" + qcount,
                                                    value: NaN;
                                                };
                                			scoreData.push(obj);
                                		}
                                		
                                	} */
                                    
                                	obj = {
                                            axis: "Q" + spotOnQ,
                                            value: calValue
                                        };
                                	scoreData.push(obj);
                                	if(isColorBlue) {
                                		for(var j = qcount;j<(qcount + totalCount); j++){
                                			blueColorQuestions.push(j);
                                		}
                                		
                                	}
                                	isColorBlue = !isColorBlue;
                                    qcount = qcount + totalCount;
                                    
                                  	//console.log("Q" + spotOnQ);
                                  	//console.log("Cal value :" + calValue);
                                  	//console.log("total count :" + totalCount);
                                  	//console.log("title : " + ss);
                                    //dummyObj = {
                                    //    axis: ss,
                                    //    value: (calValue + 0.15)
                                    //    };
                                    
                                    //indusStandards.push(dummyObj);
                          });
                        
                          
						  //for(var questionNo = 1; questionNo <= totalQuestions; questionNo++) {
							//$.each(answers,function()) {
							  //console.log("Question" + questionNo + "=" + this.val);
							  var qNumber = 1;
							  for (var ansSection in answers) {
								    if (answers.hasOwnProperty(ansSection)) {
								    	//if(answers[ansSection].hasOwnProperty(questionNo)) {
								    	var subQArray = Object.keys(answers[ansSection]);
								    	for (var qIndex = 0;  qIndex <subQArray.length;qIndex++) {
								    		var questionNo = subQArray[qIndex];
								    		if(answers[ansSection].hasOwnProperty(questionNo)) {
									    		obj = {
				                                        axis: "Q"+qNumber,
				                                        value: answers[ansSection][questionNo].val=="yes"?1:answers[ansSection][questionNo].val=="notsure"?0.5:0
				                                    };
									    		questionData.push(obj);
									    		if(answers[ansSection][questionNo].val=="yes") {
									    			obj = {
					                                        axis: "Q"+qNumber,
					                                        value: responseAvg[questionNo]["yesAvg"]
					                                    };
									    			responseAvgData.push(obj);
									    		} else if(answers[ansSection][questionNo].val=="no") {
									    			obj = {
					                                        axis: "Q"+qNumber,
					                                        value: responseAvg[questionNo]["noAvg"]
					                                    };
									    			responseAvgData.push(obj);
									    		} else if(answers[ansSection][questionNo].val=="notsure") {
									    			obj = {
					                                        axis: "Q"+qNumber,
					                                        value: responseAvg[questionNo]["notSureAvg"]
					                                    };
									    			responseAvgData.push(obj);
									    		}
								    		}
								    		//console.log("qNumber - questionNo - obj " + qNumber + " - " + questionNo + " --");
								    		//console.log(obj);
								    		qNumber = qNumber + 1;
								    	}
								    }
								}
						  //}
						  chartData.push(questionData);
                          chartData.push(responseAvgData);
                          //console.log("color qs :"+blueColorQuestions.toString());
                          //chartData.push(scoreData);
                          //chartData.push(indusStandards);
                          
                          /*****************************************************************************************/
                            var w = 500, h = 600, 
                            	//legendPosition = {x: 50, y: 550},
                                colorscale = d3.scale.ordinal().range(["#2F4696", "#999999"]),
                                //LegendOptions = ['YOUR SCORECARD','VERSUS INDUSTRY STANDARDS'],
                                LegendOptions = ['<%=spiderLegend1%>' ,'<%=spiderLegend2%>'],
                                d = chartData,
                                mycfg = {
                                    w: w,
                                    h: h,
                                    maxValue: 1,
                                    //legendPosition: legendPosition,
                                    levels: 13,
                                    ExtraWidthX: 0,
                                    axisLabelColorArray: blueColorQuestions
                                };

                            RadarChart.draw("#chart", d, mycfg);
                            
                            
                            
                            var svg = d3.select('#body')
                            .selectAll('svg')
                            .append('svg')
                            .attr("width", w+300)
                            .attr("height", h+100)
                            .attr("xmlns", "http://www.w3.org/2000/svg")
                            .attr("xmlns:xlink", "http://www.w3.org/1999/xlink")
                            .attr("version", "1.1");
							
                            //Create the title for the legend
                           
                            var text = svg.append("text")
                            .attr("class", "title")
                            .attr('transform', 'translate(90,0)') 
                            .attr("x", w + 270)
                            .attr("y", 10)
                            .attr("font-size", "12px")
                            .attr("fill", "#404040");
                            
                            var textG = d3.select('#body')
							.selectAll('svg')
							.append('g')
							.attr('class', 'label1');
							
                            
                            /*textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 450)
                            .attr("y", 75)
                            .text("Assess risks");
                           	console.dir(subSec);
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	540)
                            .attr("y", 250)
                            .attr("fill", "blue")
                            .text("Plan");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	555)
                            .attr("y", 425)
                            .text("Policies");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	555)
                            .attr("y", 440)
                            .text("& processess");
                            
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	425)
                            .attr("y", 560)
                            .attr("fill", "blue")
                            .text("Manage mobility");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	50)
                            .attr("y", 475)
                            .text("Communicate,");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	50)
                            .attr("y", 490)
                            .text("Educate");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	50)
                            .attr("y", 505)
                            .text("and Train");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	-10)
                            .attr("y", 277)
                            .attr("fill", "blue")
                            .text("Locate,");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	-10)
                            .attr("y", 292)
                            .attr("fill", "blue")
                            .text( "Monitor,");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	-10)
                            .attr("y", 307)
                            .attr("fill", "blue")
                            .text("Inform");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	20)
                            .attr("y", 160)
                            .text("Advice, assist");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	20)
                            .attr("y", 175)
                            .text("and evacuate");
                            
                            textG.append("text")
                            .attr("class", "label1")
                            .attr("text-anchor", "end")
                            .attr("x", 	125)
                            .attr("y", 75)
                            .attr("fill", "blue")
                            .text("Control and review");
                            */
                            //Initiate Legend	
                            var legend = svg.append("g")
                            .attr("class", "legend")
                            .attr("height", 200)
                            .attr("width", 100)
                            .attr('transform', 'translate(50,595)');
                            //Create colour squares
                            legend.selectAll('circle')
                            .data(LegendOptions)
                            .enter()
                            .append("circle")
                            .attr("cy", function(d, i){return i * 20;})
                            .attr("cx",50)
        					.attr("r","0.8em")
                            /* .append("rect")
                            .attr("x", 50)
                            .attr("y", function(d, i){ return i * 20;})
                            .attr("width", 10)
                            .attr("height", 10) */
                            .style("fill", function(d, i){ return colorscale(i);})
                            ;
                            //Create text next to squares
                            legend.selectAll('text')
                            .data(LegendOptions)
                            .enter()
                            .append("text")
                            .attr("x", 65)
                            .attr("y", function(d, i){ return i * 20 + 5;})
                            .attr("font-size", "13px")
                            .attr("font-weight", "bold")
                            .attr("fill", "#737373")
                            .text(function(d) { return d; })
                            ;
                          /*****************************************************************************************/

                        
                           var scoreVal = Math.round((totalYes / totalQuestions) * 100);
                          $("#score").html(scoreVal);
                          var imgSrc = './support/img/notsure.png';
						  var timgSrc = 'notsure.png';
                          if(scoreVal >= 71) {
                              imgSrc = './support/img/yes.png';
							  timgSrc = 'yes.png';
                          } else  if(scoreVal <= 40) {
                              imgSrc = './support/img/no.png';
							  timgSrc = 'no.png';
                          }
                          
                          /**********************************image upload****************************************/
                          var dateTime = new Date().getTime();
                          var uploadImageName = 'img' + dateTime + '.jpg'
                          $("#sos-graph").prop("src", imgSrc);
                          $("#scoreinfo").val(scoreVal + '|' + timgSrc + '|<%=userid%>|' + userSession.f4 + '|' + userSession.f5 + '|' + uploadImageName + '|' + userSession.f1 + '|' + userSession.f2);
			  			  var lang = '<%=lang%>';	      
                          var convertToBase64 = function(url, imagetype, callback){
                          var spiderwebImagSrc = "./support/img/spiderweb.png"
  						  var doctype = '<?xml version="1.0" standalone="no"?>'
  									  + '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">';
  						  var svgDiv = document.getElementById("chart");
  						  var source = "";
  						  var isIE="false";
	  					  var svgsetviewbox = document.getElementsByTagName("svg")[0];
	  					  svgsetviewbox.setAttribute("viewBox", "-190 -40 800 700"); 
	  					  svgsetviewbox.setAttribute("width",800);
	  					  svgsetviewbox.setAttribute("height",700);
	  					  svgsetviewbox.setAttribute("preserveAspectRatio","xMinYMin meet");
	  					  var eTextArray = $('.axis').find("text");
	  					  var qNoArray = $('.axis').find("text").text().substr(1).split("Q");
	  					  //console.log(qNoArray);
	  					  var icursor = 0;
	  					  var isBlueColor = false;
	  					  function wrap(text, width) {
	  					    text.each(function () {
	  					        var text = d3.select(this),
	  					            words = text.text().split(/\s+/).reverse(),
	  					            word,
	  					            line = [],
	  					            lineNumber = 0,
	  					            lineHeight = 1.1, // ems
	  					            x = text.attr("x"),
	  					            y = text.attr("y"),
	  					            dy = 0, //parseFloat(text.attr("dy")),
	  					            tspan = text.text(null)
	  					                        .append("tspan")
	  					                        .attr("x", x)
	  					                        .attr("y", y)
	  					                        .attr("dy", dy + "em");
	  					        while (word = words.pop()) {
	  					            line.push(word);
	  					            tspan.text(line.join(" "));
	  					            if (tspan.node().getComputedTextLength() > width) {
	  					                line.pop();
	  					                tspan.text(line.join(" "));
	  					                line = [word];
	  					                tspan = text.append("tspan")
	  					                            .attr("x", x)
	  					                            .attr("y", y)
	  					                            .attr("dy", ++lineNumber * lineHeight + dy + "em")
	  					                            .text(word);
	  					            }
	  					        }
	  					    });
	  					  }
	  					  $.each(subSec, function(secName){
	  						  var x = 0;
	  						  var y = 0;
	  						  var secQlength = this.length;
	  						  if ((secQlength % 2) != 0) y = 15; 
	  					  	  var secQLocation = Math.floor(secQlength/2);
	  					  	  var qLocation = icursor + secQLocation;
	  					  	  icursor = icursor + secQlength;
	  					  	  var colorText = isBlueColor ? "#2F4696" : "#232862";
	  					  	  for (var textNode in eTextArray) {
	  					  		  if(eTextArray[textNode].textContent == ("Q"+ qNoArray[qLocation])) {
	  					  			if(eTextArray[textNode].x.baseVal[0] == undefined) {
	  					  				  x = eTextArray[textNode].x.baseVal.getItem(0).value;
	  					  				  //console.log("x=" +eTextArray[textNode].x.baseVal.getItem(0).value);
	  					  				  //console.log("X=" + x);
		  					  			  
	  					  			  } else {
	  					  				  x = eTextArray[textNode].x.baseVal[0].value;
		  					  			  
	  					  			  }
	  					  			  if(eTextArray[textNode].y.baseVal[0] == undefined) {
	  					  				y = y + eTextArray[textNode].y.baseVal.getItem(0).value;
	  					  			    //console.log("y=" +eTextArray[textNode].y.baseVal.getItem(0).value);
	  					  			    //console.log("y=" + y);
	  					  			  } else {
	  					  				y = y + eTextArray[textNode].y.baseVal[0].value;
	  					  			  }
	  					  			  //console.log("X=" + x + " and Y =" + y);
				  					  	if(eTextArray[textNode].className.baseVal == "legend right") {
				  					  			textG.append("text")
				  	                            .attr("class", "label1")
				  	                            .attr("x", 	x + 30)
				  	                            .attr("y", y)
				  	                            .attr("text-anchor","start")
				  	                            .attr("fill", colorText)
				  	                            .text(secName)
				  	                            .call(wrap, 100);
				  					  	} else if(eTextArray[textNode].className.baseVal == "legend left") {
			  					  			textG.append("text")
			  	                            .attr("class", "label1")
			  	                            .attr("x", 	x - 30)
			  	                            .attr("y", y)
			  	                            .attr("text-anchor","end")
			  	                            .attr("fill", colorText)
			  	                            .text(secName)
			  	                            .call(wrap, 100);
				  					  	}else if(eTextArray[textNode].className.baseVal == "legend middle") {
			  					  			textG.append("text")
			  	                            .attr("class", "label1")
			  	                            .attr("x", 	x)
			  	                            .attr("y", y)
			  	                            .attr("text-anchor","start")
			  	                            .attr("fill", colorText)
			  	                            .text(secName)
			  	                            .call(wrap, 200);
			  					  	}
	  					  		  }
	  					  	  }
	  					  	isBlueColor = !isBlueColor;
                          });
						  source = (new XMLSerializer()).serializeToString(d3.select('svg').node());
						  if(source === "") {
							  isIE = "true";
							  source = (new XMLSerializer()).serializeToString(document.getElementsByTagName('svg')[0]);
						  }
						//alert(isIE);
						//document.write("source =" + source)
						var blob = new Blob([ doctype + source], { type: 'image/svg+xml;charset=utf-8' });
						var url = window.URL.createObjectURL(blob);
						var img = d3.select('body').append('img')
						 .attr('width', 500)
						 .attr('height', 500)
						 .node();
						img.onload = function(){
						var chartArea = svgDiv.getElementsByTagName('svg')[0].parentNode;
						
					    var svgNode = d3.select('svg').node();//chartArea.innerHTML;//
					    if(isIE === "true") {
					    	svgNode = (new XMLSerializer()).serializeToString(document.getElementsByTagName('svg')[0]);
					    }
					    //svgNode.setAttribute('width', 800);
						  
						   // var svgInnerHTML = svg..innerHTML + "<style>/* <![CDATA[ */.radar-chart .level{stroke:grey;stroke-width:.5}.radar-chart .axis line{stroke:grey;stroke-width:1}.radar-chart .axis .legend{font-family:sans-serif;font-size:10px}.radar-chart .axis .legend.top{dy:1em}.radar-chart .axis .legend.left{text-anchor:start}.radar-chart .axis .legend.middle{text-anchor:middle}.radar-chart .axis .legend.right{text-anchor:end}.radar-chart .tooltip{font-family:sans-serif;font-size:13px;transition:opacity 200ms;opacity:0}.radar-chart .tooltip.visible{opacity:1}.radar-chart .area{stroke-width:2;fill-opacity:.5}.radar-chart.focus .area{fill-opacity:.1}.radar-chart.focus .area.focused{fill-opacity:.7}.radar-chart .circle{fill-opacity:.9}.radar-chart .area,.radar-chart .circle{transition:opacity 300ms,fill-opacity 200ms;opacity:1}.radar-chart .d3-enter,.radar-chart .d3-exit{opacity:0}/* ]]> */</style>";
						 <%--  var linkElm = document.createElementNS("http://www.w3.org/1999/xhtml", "link");
						linkElm.setAttribute("href", "<%=webContext%>support/lib/chart/radar-chart.min.css");
						linkElm.setAttribute("type", "text/css");
						linkElm.setAttribute("rel", "stylesheet"); --%>
					  	var style = document.createElement("style");
					    style.setAttribute("type", "text/css");
					  	var styleData = document.createTextNode(".radar-chart .level{stroke:grey;stroke-width:.5}.radar-chart .axis line{stroke:grey;stroke-width:1}.radar-chart .axis .legend{font-family:sans-serif;font-size:12px}.radar-chart .axis .legend.top{dy:1em}.radar-chart .axis .legend.left{text-anchor:end}.radar-chart .axis .legend.middle{text-anchor:middle}.radar-chart .axis .legend.right{text-anchor:start}.radar-chart .tooltip{font-family:sans-serif;font-size:13px;transition:opacity 200ms;opacity:0}.radar-chart .tooltip.visible{opacity:1}.radar-chart .area{stroke-width:2;fill-opacity:.5}.radar-chart.focus .area{fill-opacity:.1}.radar-chart.focus .area.focused{fill-opacity:.7}.radar-chart .circle{fill-opacity:.9}.radar-chart .area,.radar-chart .circle{transition:opacity 300ms,fill-opacity 200ms;opacity:1}.radar-chart .d3-enter,.radar-chart .d3-exit{opacity:0}.radar-chart .label1{font-family:sans-serif;font-size:14px}");
					  	style.appendChild(styleData);
				    	//style.appendChild(document.createTextNode("@import url('radar-chart.min.css')"));
				    	 if(isIE === "true") {
				    		svgNode = svgNode.substr(0, svgNode.indexOf(">")+1) + style.outerHTML + svgNode.substr(svgNode.indexOf(">")+1);
				    	 } else {
				    		svgNode.insertBefore(style,svgNode.firstChild);
				    	 }
  							    	//svgNode.appendChild(style);
  							    	//svgNode.insertBefore(style,svgNode.firstChild);
  							    	//document.write(svgNode.outerHTML);
  								  //svg.append("style").text("<style>.radar-chart .level{stroke:grey;stroke-width:.5}.radar-chart .axis line{stroke:grey;stroke-width:1}.radar-chart .axis .legend{font-family:sans-serif;font-size:10px}.radar-chart .axis .legend.top{dy:1em}.radar-chart .axis .legend.left{text-anchor:start}.radar-chart .axis .legend.middle{text-anchor:middle}.radar-chart .axis .legend.right{text-anchor:end}.radar-chart .tooltip{font-family:sans-serif;font-size:13px;transition:opacity 200ms;opacity:0}.radar-chart .tooltip.visible{opacity:1}.radar-chart .area{stroke-width:2;fill-opacity:.5}.radar-chart.focus .area{fill-opacity:.1}.radar-chart.focus .area.focused{fill-opacity:.7}.radar-chart .circle{fill-opacity:.9}.radar-chart .area,.radar-chart .circle{transition:opacity 300ms,fill-opacity 200ms;opacity:1}.radar-chart .d3-enter,.radar-chart .d3-exit{opacity:0}</style>");
  								  //console.log(chartArea.offsetWidth);
  								  var canvas = d3.select('body').append('canvas').node();
  								canvas.setAttribute('width', chartArea.offsetWidth);
  							    canvas.setAttribute('height', chartArea.offsetHeight);
  							  canvas.setAttribute(
  							        'style',
  							        'position: absolute; ' +
  							      	'top: ' + (-chartArea.offsetHeight * 2) + 'px;' +
  							      	'left: ' + (-chartArea.offsetWidth * 2) + 'px;');
  							
  							
  								  var ctx = canvas.getContext('2d');
  								//var svgNodeText = svgNode.outerHTML;
  							    //svgNodeText = svgNodeText.replace('width="500"', 'width="800"');   
  							    //svgNodeText = svgNodeText.replace('height="600"', 'height="600"');

  									// Calculate scaling factors
  								   // var width_scale_factor  = 800 / 500;
  									//var height_scale_factor = 600 / 600;
  									
  								// Scale the SVG object
  									//svgNode.outerHTML = svgNodeText.replace('<svg ', '<svg transform="scale(' + width_scale_factor + ', ' + height_scale_factor + ')" ');
  									

  								  //
  								  //ctx.drawImage(img, 0, 0);
//   								  var serializer = new XMLSerializer();
//   								  var svgString = serializer.serializeToString(svg);
  								  //d3.select('svg').node().outerHTML.trim().replace('&nbsp;',' ')
  								  //alert(svgNode);
  								  //alert(svgNode.indexOf("points="));
  								  //alert(canvas.outerHTML);
  								  //document.write(svgNode);
  								  if(isIE === "true") {
  								  	canvg(canvas,svgNode,{ ignoreMouse: true, ignoreAnimation: true });
  								  } else {
  									canvg(canvas,svgNode.outerHTML,{ ignoreMouse: true, ignoreAnimation: true});//, offsetX:0, offsetY:0, ignoreDimensions: true, ignoreClear: true
  								  }
  								  var data1 = ctx.getImageData(0, 0, canvas.width, canvas.height);
  								  var compositeOperation = ctx.globalCompositeOperation;
  								  ctx.globalCompositeOperation = "destination-over";
	   						      ctx.fillStyle = '#f2f2f2';
	 							  ctx.fillRect(0, 0, canvas.width, canvas.height);
	 							  //console.log("canvas height",canvas.height);
	 							  //console.log(canvas);
	 							  //console.log(svgNode);
  								  data = canvas.toDataURL("image/png");
  								  ctx.clearRect (0,0,canvas.width, canvas.height);
  								  ctx.putImageData(data1, 0,0);
  								  ctx.globalCompositeOperation = compositeOperation; 
  									//document.write(data);
  								  //alert(data);
  	                              callback(data);
  	                             svgsetviewbox.setAttribute("viewBox", "-90 -30 800 700"); 
  								  var canvasUrl = canvas.toDataURL("image/png");
  								  var img2 = d3.select('body').append('img')
  								    .attr('width', 400)
  								    .attr('height', 300)
  								    .node();
  								  img2.src = canvasUrl; 
  								  canvas.style.visibility = 'hidden';
  								img2.style.visibility = 'hidden';
  								  //canvas.remove();
  								  //img2.remove();
  								}
  								//
  								img.src = url;
  								img.style.visibility = 'hidden';
  								//img.remove();
                    	 };
                    	convertToBase64("<%=webContext%>/support/img/spiderweb.png", "image/png", function(data){
					//document.write("\ndata=" + data);      
					var formData = new FormData();
					formData.append('scoreinfo', $("#scoreinfo").val());
					formData.append('filename', uploadImageName);
					formData.append('language', lang);
					formData.append('picture', data);
					$("#btnPrintPDF").hide();
 								$.ajax({
                           	    //async : false,
 									url: "<%=webContext%>/image",
								type : "POST",
								cache : false,
								contentType : false,
								processData : false,
								data : formData,
								success: function(pdfFileName) {
									//alert(pdfFileName);
									$('#pdfFilePath').val(pdfFileName);
								}
							})
							 .done(
									function(pdfFileName) {
										//$('#pdfFilePath').val(pdfFileName);
									});
 								
								$("#btnPrintPDF").delay(8000).show(0);
							//$('#spiderWeb').val(data);

						});
						//                   	 		function SVG2PNG(svg, callback) {
						// 								  var canvas = document.createElement('canvas'); // Create a Canvas element.
						// 								  var ctx = canvas.getContext('2d'); // For Canvas returns 2D graphic.
						// 								  var data = svg.outerHTML; // Get SVG element as HTML code.
						// 								  canvg(canvas, data); // Render SVG on Canvas.
						// 								  callback(canvas); // Execute callback function.
						// 								}

						// 								 	var svgDiv =$("#chart");
						// 									var svg = svgDiv[0].outerHTML;
						// 									SVG2PNG(svg, function(canvas) { // Arguments: SVG element, callback function.
						// 									    var base64 = canvas.toDataURL("image/png"); // toDataURL return DataURI as Base64 format.
						// 									    $('#spiderWeb').val(base64);
						// 									  });
					});
		      			//localStorage.clear();
									</script>
									<input type="hidden" id="scoreinfo" name="scoreinfo" value="" />
									<input type="hidden" id="pdfFilePath" name="pdfFilePath" value="" />
									<!--<input type="hidden" id="spiderWeb" name="spiderWeb" />-->
									<div
										class="question_template col-xs-12 col-sm-12 col-md-12 col-lg-12"
										style="display: none;">
										<div class="question_id" style="display: block;">
											<div class="left col-xs-12 col-sm-6 col-md-6 col-lg-7">
												<div class="padding">
													<span class="question_number"></span>
													<p class="question_text"></p>
												</div>
											</div>
											<div class="right col-xs-12 col-sm-6 col-md-6 col-lg-5">
												<div class="padding">
													<p class="last question_desc"></p>
												</div>
											</div>
										</div>
									</div>
									<div id="body">
										<div id="chart"></div>
									</div>
									<div id="sos-subsection-graph-grand-wrapper"
										class="hidden sos-subsection-graph-grand-wrapper">
										<div id="sos-subsection-graph-wrapper"
											class="sos-subsection-graph-wrapper"></div>
									</div>

                      <template>
                        <div class="sos-subsection-graph"></div>
                      </template>


                      <div id="plan" style="display: none;">
                        <%--<div class="section_header"></div>--%>
                        <div class="plan-section-header">
                          <div class="plan-section-style col-xs-12 col-sm-6 col-md-6 col-lg-7">
                            <!--<span class="plan-icon"></span>-->
                            <div class="plan-header-text-section">
                             <div class="plan-header-text"><%= secName1 %></div>
                              <div class="plan-header-desc"><%= planHeaderDesc %>
                              
                              </div>
                            </div>
                          </div>
                          <div class="plan-section-style hidden-xs col-sm-6 col-md-6 col-lg-5">
                            <div class="plan-header-text">&nbsp;<%=actionlabel%></div>
                          </div>
                        </div>
                        <div class="section_questions stripe">
                          <div class="white_line plan_section">

                          </div>
                        </div>
                      </div>

                      <div id="do" style="display: none;">
                        <div class="do-section-header">
                          <div class="plan-section-style col-xs-12 col-sm-6 col-md-6 col-lg-7">
                            <!--<span class="do-icon"></span>-->
                            <div class="plan-header-text-section">
                              <div class="plan-header-text"><%= secName2 %></div>
                              <div class="plan-header-desc">
                              <%=doHeaderDesc%>
                                
                              </div>
                            </div>
                          </div>
                          <div class="plan-section-style hidden-xs col-sm-6 col-md-6 col-lg-5">
                            <div class="plan-header-text">&nbsp;<%=actionlabel%></div>
                          </div>
                        </div>
                        <div class="section_questions stripe">
                          <div class="white_line do_section">

                          </div>
                        </div>
                      </div>

                      <div id="check" style="display: none;">
                        <div class="check-section-header">
                          <div class="plan-section-style col-xs-12 col-sm-6 col-md-6 col-lg-7">
                            <!--<span class="check-icon"></span>-->
                            <div class="plan-header-text-section">
                              <div class="plan-header-text"><%= secName3 %></div>
                              <div class="plan-header-desc">
                              <%=checkHeaderDesc%>
                              </div>
                            </div>
                          </div>
                          <div class="plan-section-style hidden-xs col-sm-6 col-md-6 col-lg-5">
                            <div class="plan-header-text">&nbsp;<%=actionlabel%></div>
                          </div>
                        </div>
                        <div class="section_questions stripe">
                          <div class="white_line check_section">

                          </div>
                        </div>
                      </div>

                      <div id="footer" class="inner img-responsive">
                      <h3><%=lastParaHeading%></h3>
                      <p><%=lastParagraph1%><a href="http://www.internationalsos.com/" target="_blank">www.internationalsos.com</a></p>
                      <p><em><%=lastParagraph2%> <%=lastParagraph3%></em></p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
              <img class="image-max-width" src="<%=webContext%>support/img/strapline.png" alt="Worldwide reach. Human touch.">
            </div>
          </div>
        </div>
      </form>
      
    </body>
  </html>

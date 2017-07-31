<!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
    <%@ page import="java.util.*" %>
    <head>
      <%
        String webContext = "";
        String userid = (String) request.getAttribute("userid");
      %>
      <script>
        var userSession = JSON.parse(localStorage.getItem("userInfo")),
        surveyProgress = {},
        answers = {};

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
      <link href="<%=webContext%>support/lib/bootstrap.min.css" rel="stylesheet">
      <link href="<%=webContext%>support/lib/chart/radar-chart.min.css" rel="stylesheet">
      <link href="<%=webContext%>support/css/site.css" rel="stylesheet">
      <script type="text/javascript" async="" src="<%=webContext%>support/js/ga.js"></script>
      <script src="<%=webContext%>/support/lib/jquery-3.2.0.js"></script>
      <script src="<%=webContext%>support/lib/bootstrap.min.js"></script>
      <script src="<%=webContext%>support/lib/chart/d3.v3.min.js"></script>
      <script src="<%=webContext%>support/lib/chart/radar-chart.min.js"></script>
      <script type="text/javascript" async="" src="<%=webContext%>support/js/assessment.js"></script>
    </head>

    <body>
      <form name="reportForm" method="post" action="" id="reportForm">
		<input type="hidden" id="score1" name="score1" value="42"/>
		<input type="hidden" id="username1" name="username1" value="scas"/>
        <div class="container">
          <div id="outer" class="row">
            <div id="header" class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">
              <div id="logo" class="pull-right"></div>
            </div>
            <div id="content_wrap" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
              <div class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <div id="results" style="">
                  <div class="results-header">
                    <img class="cover-width" src="./support/img/result_header.png" alt="Sections">
                    <a id="btnPrintPDF" href="/print" target="_blank" onClick="javascript:updateA();"></a>
                  </div>
                  <div class="content">
                    <div class="results_h2_wrap stripe">
                      <h2><%= scoreLable %> <span id="score"></span>%</h2>
                    </div>
                    <div class="results_padding">
                      <div id="graph" class="action_needed1">
                        <img class="cover-width action-consider" id="sos-graph" src="" alt="Action Consider">
                      </div>

                      <script>
						function updateA() {
                            if($("#btnPrintPDF").attr("href").indexOf("?scoreinfo") === -1) {
							    $("#btnPrintPDF").attr("href", $("#btnPrintPDF").attr("href")+"?scoreinfo=" + $("#scoreinfo").val());
                            }
						}
                        $(document).ready(function () {
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
                                  if(showQuestion !== 'yes') {
                                    var tmpl = $('.question_template').clone(true);
                                    tmpl.find('.question_id').id = qid;
                                    tmpl.find('.question_number')[0].innerText = "Q" + qNum;
                                    tmpl.find('.question_text')[0].innerText = this.qry;
                                    tmpl.find('.question_desc')[0].innerText = "this is description for this question: " + this.qry;
                                    tmpl.show();
                                    $("." + sectionName + "_section")[0].appendChild(tmpl[0]);
                                  }
                                });
                                totalQuestions += qNum;
                                if(qNum > 0) {
                                  $("#" + sectionName).show();
                                }
                              };
                          generateForm('plan');
                          generateForm('do');
                          generateForm('check');
                          var scoreData = [], indusStandards = [], chartData = [];
                          $.each(subSec, function(ss) {
                                var totalCount = this.length,
                                    totalYesCount = this.filter(function(value){
                                        return value === 'yes';
                                    }).length,
                                    perCalValue = (totalYesCount * 100) / totalCount,
                                    calValue = perCalValue / 100,
                                    /*calValue2 = ((calValue.toFixed(2)) + '').replace('.00', '') + '%',
                                    titleVal = ss + ' (' + calValue + ')';*/
                                    obj = {
                                        axis: ss,
                                        value: calValue
                                    };
                                    /*dummyObj = {
                                        axis: ss,
                                        value: (calValue + 0.15)
                                        };*/
                                    scoreData.push(obj);
                                    //indusStandards.push(dummyObj);
                          });

                          chartData.push(scoreData);
                          //chartData.push(indusStandards);
                          
                          /*****************************************************************************************/
                            var w = 400, h = 500, 
                                colorscale = d3.scale.category10(),
                                //LegendOptions = ['YOUR SCORECARD','VERSUS INDUSTRY STANDARDS'],
                                LegendOptions = ['YOUR SCORECARD'],
                                d = chartData,
                                mycfg = {
                                    w: w,
                                    h: h,
                                    maxValue: 1,
                                    levels: 10,
                                    ExtraWidthX: 0
                                };

                            RadarChart.draw("#chart", d, mycfg);

                            var svg = d3.select('#body')
                            .selectAll('svg')
                            .append('svg')
                            .attr("width", w+300)
                            .attr("height", h);

                            //Create the title for the legend
                            var text = svg.append("text")
                            .attr("class", "title")
                            .attr('transform', 'translate(90,0)') 
                            .attr("x", w + 270)
                            .attr("y", 10)
                            .attr("font-size", "12px")
                            .attr("fill", "#404040");

                            //Initiate Legend	
                            var legend = svg.append("g")
                            .attr("class", "legend")
                            .attr("height", 100)
                            .attr("width", 100)
                            .attr('transform', 'translate(-195, 15)') 
                            ;
                            //Create colour squares
                            legend.selectAll('rect')
                            .data(LegendOptions)
                            .enter()
                            .append("rect")
                            .attr("x", w - 65)
                            .attr("y", function(d, i){ return i * 20;})
                            .attr("width", 10)
                            .attr("height", 10)
                            .style("fill", function(d, i){ return colorscale(i);})
                            ;
                            //Create text next to squares
                            legend.selectAll('text')
                            .data(LegendOptions)
                            .enter()
                            .append("text")
                            .attr("x", w - 52)
                            .attr("y", function(d, i){ return i * 20 + 9;})
                            .attr("font-size", "11px")
                            .attr("fill", "#737373")
                            .text(function(d) { return d; })
                            ;
                          /*****************************************************************************************/

                          var scoreVal = Math.round((totalYes / totalQuestions) * 100);
                          $("#score").html(scoreVal);
                          var imgSrc = './support/img/notsure.png';
						  var timgSrc = 'notsure.png';
                          if(totalYes === totalQuestions) {
                              imgSrc = './support/img/yes.png';
							  timgSrc = 'yes.png';
                          } else if(totalNo === totalQuestions) {
                              imgSrc = './support/img/no.png';
							  timgSrc = 'no.png';
                          }

                          $("#sos-graph").prop("src", imgSrc);
                          $("#scoreinfo").val(scoreVal + '|' + timgSrc + '|<%= userid %>|' + userSession.f4 + '|' + userSession.f1 + '|' + userSession.f2);

                        });
                      </script>
                       <input type="hidden" id="scoreinfo" name="scoreinfo" value="" />

                      <div class="question_template col-xs-12 col-sm-12 col-md-12 col-lg-12" style="display: none;">
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
                      <div id="sos-subsection-graph-grand-wrapper" class="hidden sos-subsection-graph-grand-wrapper">
                          <div id="sos-subsection-graph-wrapper" class="sos-subsection-graph-wrapper">
                          </div>
                      </div>

                      <template>
                        <div class="sos-subsection-graph"></div>
                      </template>


                      <div id="plan" style="display: none;">
                        <%--<div class="section_header"></div>--%>
                        <div class="plan-section-header">
                          <div class="plan-section-style col-xs-12 col-sm-6 col-md-6 col-lg-7">
                            <span class="plan-icon"></span>
                            <div class="plan-header-text-section">
                              <div class="plan-header-text">Plan</div>
                              <div class="plan-header-desc">
                              Key stakeholders are identified and the framework for how the organisation manages travel health and security risks is defined.
                              </div>
                            </div>
                          </div>
                          <div class="plan-section-style hidden-xs col-sm-6 col-md-6 col-lg-5">
                            <div class="plan-header-text">&nbsp;Actions</div>
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
                            <span class="do-icon"></span>
                            <div class="plan-header-text-section">
                              <div class="plan-header-text">Do</div>
                              <div class="plan-header-desc">
                                Travel risk management plan is implemented and tools are deployed.
                              </div>
                            </div>
                          </div>
                          <div class="plan-section-style hidden-xs col-sm-6 col-md-6 col-lg-5">
                            <div class="plan-header-text">&nbsp;Actions</div>
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
                            <span class="check-icon"></span>
                            <div class="plan-header-text-section">
                              <div class="plan-header-text">Check</div>
                              <div class="plan-header-desc">
                                The implementation of the travel risk management plan is regularly tested and maintained, enabling continuous improvement.
                              </div>
                            </div>
                          </div>
                          <div class="plan-section-style hidden-xs col-sm-6 col-md-6 col-lg-5">
                            <div class="plan-header-text">&nbsp;Actions</div>
                          </div>
                        </div>
                        <div class="section_questions stripe">
                          <div class="white_line check_section">

                          </div>
                        </div>
                      </div>

                      <div id="footer" class="inner img-responsive">
                      <h3>Integrated Travel Risk Mitigation, a Duty of Care Plan-Do-Check approach</h3>
                      <div class="diagram-area">
                        <%--<a href="http://www.global.selfassessmenttool.com/img/diagram.png" target="_blank"><div class="diagram"></div></a>--%>
                        <a href="http://www.global.selfassessmenttool.com/img/diagram.png" target="_blank"><img class="cover-width diagram" src="./support/img/resourceFiles/do-12.png" alt="Sections"></a>
                        <a href="http://www.global.selfassessmenttool.com/img/diagram.png" class="marginleft" target="_blank">Click here to open larger image of Integrated Travel Risk Mitigation</a>
                      </div>
                      <p>International SOS commissioned the first ever Duty of Care whitepaper. This reviews employersâ Duty of Care responsibilities and offers guidelines for the development of appropriate risk management strategies.</p>
                      <p>Following this sector first, our clients requested more research, tools and advice. Resulting in the commission of our Duty of Care and Travel Risk Management Global Benchmarking Study â the first comprehensive and authoritative research publication on the topic.</p>
                      <p>The paper outlines a framework for organisations to ensure they are adequately meeting their Duty of Care obligations. The framework follows the 'plan-do-check' approach.</p>
                      <p>For more information <a href="http://internationalsos.com/duty-of-care" target="_blank">internationalsos.com/duty-of-care</a> </p>
                      <h3>Need assistance with any of your responses or recommendations?</h3>
                      <p>Contact International SOS - <a href="mailto:inquiries@internationalsos.com">inquiries@internationalsos.com</a> | <a href="http://www.internationalsos.com/" target="_blank">www.internationalsos.com</a></p>
                      <p><em>The recommendations, suggested actions and broad maturity measure are for guidance purposes only and do not constitute formal advice. Please contact International SOS for customised analysis and recommendations specific to your organisation.</em></p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <%--<div id="footer" class="inner img-responsive">--%>
              <img class="image-max-width" src="<%=webContext%>support/img/strapline.png" alt="Worldwide reach. Human touch.">
            </div>
          </div>
        </div>
      </form>
      
    </body>
  </html>

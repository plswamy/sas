

$(document).ready(function () {


  /** init assessment tool **/
  section1QuestionCount = $("div.question[data-section-id='1']").length;
  section2QuestionCount = $("div.question[data-section-id='2']").length;
  section3QuestionCount = $("div.question[data-section-id='3']").length;


  // bind yes/no/not-sure button
  $('.question .answer_wrap .btn').on('click', function (event) {
    var infoEle = $(this).closest('.answer_wrap'),
        sectionId = infoEle.attr('data-section'),
        questionId = infoEle.attr('data-qid'),
        val = $(this).attr('data-value');
    console.log(val);

    if(!!localStorage.userInfo) {
      var userInfo = JSON.parse(localStorage.getItem("userInfo"));
      if(!!userInfo.surveyProgress) {
      } else {
        userInfo.surveyProgress = {};
      }
      if(!!userInfo.surveyProgress[sectionId]) {
        userInfo.surveyProgress[sectionId][questionId] = {"val" : val};
      } else {
        userInfo.surveyProgress[sectionId] = {};
        userInfo.surveyProgress[sectionId][questionId] = {"val" : val};
      }
      localStorage.setItem("userInfo", JSON.stringify(userInfo));
    } else {
      //Error handling
    }

    //deepObjectExtend(userInfo, allSections);
    var ding =deepObjectExtend(userInfo.surveyProgress, allSections);
    fillForm(ding);
    console.log("saved current question information");

  });

  // show first question progress
  //$('#progressBarInner').width(calculateProgress(1, section1QuestionCount) + "%");
});

function calculateProgress(questionID, numberOfQuestions) {
  return Number(Number(questionID) / Number(numberOfQuestions) * 100).toFixed(2);
}
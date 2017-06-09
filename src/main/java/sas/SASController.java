
package sas;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import java.security.Principal;

import org.jdom.Document;
import org.jdom.input.SAXBuilder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;

import sas.bean.Question;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Enumeration;
import java.util.List;
import java.util.StringTokenizer;
@Controller
public class SASController {

	@Autowired
	DataSource dataSource;
	
	@Autowired
	private HttpServletRequest req;
	
	Connection con = null;
	PreparedStatement stmt = null;
	
  @RequestMapping("/helloworld")
  public ModelAndView hello(ModelMap model,Principal principal) {

    String loggedInUserName=principal.getName();

    return new ModelAndView("hello", "userName", loggedInUserName);
  }

  @PreAuthorize("hasRole('ROLE_ADMIN')")
  @RequestMapping("/admin")
  public ModelAndView helloAdmin(ModelMap model,Principal principal) {
	  System.out.println("helloAdmin called");
	  String requestedLang = req.getParameter("language");
	  System.out.println("requested Lang from page is :"+requestedLang);
	  String loggedInUserName=principal.getName();
	  req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", requestedLang));
	  req.setAttribute("questions", getQuestions(requestedLang));
	  if(nullCheck(requestedLang).length() > 0) {
		  req.setAttribute("language", requestedLang);
	  }
	  return new ModelAndView("admin", "userName", loggedInUserName);
  }

  @RequestMapping("/normal-user")
  public ModelAndView helloNormalUser(ModelMap model,Principal principal) {
    String loggedInUserName=principal.getName();
    return new ModelAndView("normal_user", "userName", loggedInUserName);
  }
  
  @RequestMapping(value="/hello", method = RequestMethod.GET)
  public String hello(ModelMap model) {
	  System.out.println("hello called");
	  loadData();
	  return "index";

  }


  @RequestMapping(value="/login", method = RequestMethod.GET)
  public String login(ModelMap model) {

    return "login";

  }
  @RequestMapping(value="/survey", method = RequestMethod.GET)
  public String surveyGet(ModelMap model) {
		
		System.out.println("survey get called....");
		req.setAttribute("questions", getQuestions(null));
  	  	req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", null));
		//req.setAttribute("answertypes", getData("answers", "answertype", "answertypevalue"));
		return "survey";
  }

  @RequestMapping(value="/survey", method = RequestMethod.POST)
  public String survey(ModelMap model, HttpSession session, HttpServletRequest request) {
	  	System.out.println("survey post called....");
		System.out.println("ctl00$ContentPlaceHolder1$tbxLastName ==="+model.get("ctl00$ContentPlaceHolder1$tbxLastName"));
		System.out.println("request getParameter ===="+request.getParameter("ctl00$ContentPlaceHolder1$tbxLastName"));

		req.setAttribute("questions", getQuestions(null));
  	  	req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", null));
		//req.setAttribute("answertypes", getData("answers", "answertype", "answertypevalue"));
		return "report";

  }
  
  @RequestMapping(value="/report", method = RequestMethod.POST)
  public String postReport(ModelMap model) {
	  	System.out.println("report post called....");
	  	System.out.println("email ....:"+req.getParameter("email"));
		saveUser();
		saveUserResponse();
		return "report";
  }

  
  @RequestMapping(value="/report", method = RequestMethod.GET)
  public String getReport(ModelMap model) {
	  System.out.println("report get called....");
    return "survey";

  }
  
  @RequestMapping(value="/admin", method = RequestMethod.POST)
  public String postAdmin(ModelMap model) {
	  	System.out.println("admin post called....");
	  	saveLangData();
		return "report";
  }
  


  @RequestMapping(value="/home", method = RequestMethod.POST)
  public String home(ModelMap model) {
	System.out.println("home called");
    return "survey";

  }

  @RequestMapping(value="/", method = RequestMethod.POST)
  public String home1(ModelMap model) {
	System.out.println("home1 called");
    return "survey";
  }
  
  @RequestMapping(value="/", method = RequestMethod.GET)
  public String homeGet1(ModelMap model) {
	  System.out.println("homeGet1");
	  loadData();
	  return "index";

  }
  
  @RequestMapping(value="/home", method = RequestMethod.GET)
  public String homeGet(ModelMap model) {
	  System.out.println("homeGet");
	  loadData();
    return "index";

  }
  
  @RequestMapping(value="/print", method = RequestMethod.GET)
  public String printGet(ModelMap model) {
	  System.out.println("printGet");
	  generatePDF();
	  return "print";
  }
  
  private void generatePDF() {
	  try{
	  	System.out.println("begin");
	  	long l = System.currentTimeMillis();	
	  	String realPath = req.getRealPath("/");
	  	System.out.println("realPath:"+realPath);
		String pdfFileName = realPath+"/pdf/pdf"+l+".pdf";
		req.setAttribute("pdffile", "pdf"+l+".pdf");				
		String xslFileName = realPath+"/xsl/cmsedgexsl.xsl";		
		String xmlFileName = realPath+"/xsl/travel.xml";		
		SAXBuilder builder = new SAXBuilder();
		Document document = builder.build(xmlFileName);		
		Doc2Pdf.start(document, xslFileName, pdfFileName);
		System.out.println("end");
	  } catch(Exception exp) {
		  exp.printStackTrace();
	  }
  }


  @RequestMapping(value="/loginError", method = RequestMethod.GET)
  public String loginError(ModelMap model) {
    model.addAttribute("error", "true");
    return "login";
  }

  // for 403 access denied page
    @RequestMapping(value = "/403", method = RequestMethod.GET)
    public ModelAndView accesssDenied(Principal user) {

      ModelAndView model = new ModelAndView();
      if (user != null) {
        model.addObject("msg", "Hi " + user.getName()
        + ", You can not access this page!");
      } else {
        model.addObject("msg",
        "You can not access this page!");
      }

      model.setViewName("403");
      return model;
    }
    
    public Hashtable<String, List<Question>> getQuestions(String lang) {
    	Hashtable<String, List<Question>> hs = new Hashtable<String, List<Question>>();
    	List<Question> list = null;
    	Question q = null;
    	try {
    		con = dataSource.getConnection();
    		stmt = con.prepareStatement("select * from questions where lang = ? order by id");
    		if(nullCheck(lang).length() == 0 || lang.equals("en")) {
    			lang = "english";
    		}
    		stmt.setString(1, lang);
    		ResultSet rs = stmt.executeQuery();
    		while(rs.next()) 
    		{    		
    			q = new Question();
    			q.setId(rs.getString("id"));
    			q.setType(rs.getString("qtype"));
    			q.setImageName(rs.getString("imagename"));
    			q.setText(rs.getString("qtext"));
    			q.setDesc(rs.getString("qdesc"));
    			q.setLang(rs.getString("lang"));
    			list = hs.get(q.getType());
    			if(list == null) {
    				list = new ArrayList<Question>();
    			}
				list.add(q);
				hs.put(q.getType(), list);    				    			
    		}
    		if(hs.size() == 0) {
    			hs = getQuestions("english");
    		}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();
    	}
    	return hs;
    }
    
    public List<Question> getQuestionsAsList() {
    	List<Question> list = new ArrayList<Question>();
    	Question q = null;
    	try {
    		con = dataSource.getConnection();
    		stmt = con.prepareStatement("select * from questions order by id");
    		ResultSet rs = stmt.executeQuery();
    		while(rs.next()) 
    		{    		
    			q = new Question();
    			q.setId(rs.getString("id"));
    			q.setType(rs.getString("qtype"));
    			q.setImageName(rs.getString("imagename"));
    			q.setText(rs.getString("qtext"));
    			q.setDesc(rs.getString("qdesc"));
    			q.setLang(rs.getString("lang"));
				list.add(q);			    			
    		}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();
    	}
    	return list;
    }
    
    private void loadData() {
  	  	req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", null));
	  	req.setAttribute("businessindustry", getData("businessindustry", "boption", "boptionvalue", null));
	  	req.setAttribute("country", getData("country", "coption", "coptionvalue", null));
	  	//req.setAttribute("labels", getData("labels", "labelkey", "labelvalue"));	  	
  	  	
  	  	// load country list
  	  	// load business industry
  	  	// load state
    }
    
    public Hashtable<String, String> getData(String table, String cKey, String cValue, String lang) {    	
    	Hashtable<String, String> hs = new Hashtable<String, String>();
    	try {
    		con = dataSource.getConnection();
    		stmt = con.prepareStatement("select * from "+table+" where lang = ? order by id");
    		if(nullCheck(lang).length() == 0 || lang.equals("en")) {
    			lang = "english";
    		}
    		stmt.setString(1,  lang);
    		ResultSet rs = stmt.executeQuery();
    		while(rs.next()) 
    		{
    			hs.put(rs.getString(cKey), rs.getString(cValue));
    		}
    		if(hs.size() == 0) {
    			hs = getData(table, cKey, cValue, "english");
    		}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();
    	}
    	return hs;
    }
    
    private void saveUser() {
    	System.out.println("save user called");
    	try {
    		con = dataSource.getConnection();
    		stmt = con.prepareStatement("insert into registrationinfo (firstname, lastname, jobtitle, email, company, businesstype, country, state, lang) values (?,?,?,?,?,?,?,?,?)");
    		stmt.setString(1, nullCheck(req.getParameter("firstname")));
    		stmt.setString(2, nullCheck(req.getParameter("lastname")));
    		stmt.setString(3, nullCheck(req.getParameter("jobtitle")));
    		stmt.setString(4, nullCheck(req.getParameter("email")));
    		stmt.setString(5, nullCheck(req.getParameter("company")));
    		stmt.setString(6, nullCheck(req.getParameter("businessindustry")));
    		stmt.setString(7, nullCheck(req.getParameter("country")));
    		stmt.setString(8, nullCheck(req.getParameter("state")));
    		stmt.setString(9, "english");
    		stmt.executeUpdate();
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();    		
    	}
    }
    
    private void close() {
    	try {
    		if(stmt != null) stmt.close();
    		if(con != null) con.close();
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	}
    }
    private void saveUserResponse() {
    	System.out.println("save user response called");
    	String userid = getUserId(nullCheck(req.getParameter("email")));
    	/*List<Question> list = getQuestionsAsList();*/
    	String userRes = nullCheck(req.getParameter("userResponse"));
    	if(userRes.length() > 0) {
	    	StringTokenizer st = new StringTokenizer(userRes, "|");
	    	String temp = null;
	    	StringTokenizer tempst = null;
	    	String sql = "insert into userresponse (userid, qid, qresponse) values (?,?,?)";
	    	try {
	    		con = dataSource.getConnection();
	    		stmt = con.prepareStatement(sql); 
				while(st.hasMoreElements()) {
					temp = st.nextToken();
					tempst = new StringTokenizer(temp, ":");
					stmt.setString(1, userid);
					stmt.setString(2, tempst.nextToken());
					stmt.setString(3, tempst.nextToken());
					stmt.executeUpdate();
				}    		
	    	} catch(Exception exp) {
	    		exp.printStackTrace();
	    	} finally {
	    		close();
	    	}
    	}
    }
    
    private String getUserId(String key) {
    	String id = null;
    	try {
    		con = dataSource.getConnection();
    		stmt = con.prepareStatement("select id from registrationinfo where email='"+key+"'");
    		ResultSet rs = stmt.executeQuery();
    		if(rs.next()) {
    			id = rs.getString(1);
    		}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();
    	}
    	return id;
    }
    
    private void saveLangData() {
    	try {    	    		    	
    		String lang = req.getParameter("lang");
	    	boolean update = getData(lang);
	    	if(update) {
	    		System.out.println("updating data for lang:"+lang);
	    		updateData();
	    	} else {
	    		System.out.println("inserting data for lang:"+lang);
	    		insertData();
		    	
	    	}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();
    	}
    }
    
    private void updateData() {
    	String labels = req.getParameter("labels");
    	String questions = req.getParameter("questions");
    	String lang = req.getParameter("lang");
    	System.out.println("lang:"+lang);
    	System.out.println("labels:"+labels);	    	
    	System.out.println("questions:"+questions);
    	try {
    		String temp1 = null;
    		String temp2 = null;
    		String temp3 = null;
    		String temp4 = null;
    		String temp5 = null;
    		con = dataSource.getConnection();
    		StringTokenizer st = null;
    		//update labels set labelvalue='test' where labelkey='welcomeDesc' and lang='en1';
	    	String labelInsert = "update labels set labelvalue=? where labelkey=? and lang=?";
	    	stmt = con.prepareStatement(labelInsert);
	    	StringTokenizer labelsToken = new StringTokenizer(labels, "|");
	    	while(labelsToken.hasMoreElements()) {
	    		st = new StringTokenizer(labelsToken.nextToken(), ":");
	    		//labelKey:labelvalue
	    		temp1 = st.nextToken();
	    		temp2 = st.nextToken();
	    		stmt.setString(1, temp2);
	    		stmt.setString(2, temp1);
	    		stmt.setString(3, lang);
		    	stmt.executeUpdate();
	    	}
	    	
	    	String questionInsert = "update questions set qtext = ?, qdesc = ?, imagename = ? where id = ?";	    	
	    	stmt = con.prepareStatement(questionInsert);
	    	StringTokenizer qToken = new StringTokenizer(questions, "|");
	    	while(qToken.hasMoreElements()) {
	    		st = new StringTokenizer(qToken.nextToken(), ":");
	    		//id:section:question:desc:imageName
	    		temp1 = st.nextToken(); //id
	    		temp2 = st.nextToken(); //qtype
	    		temp3 = st.nextToken(); //qtext
	    		temp4 = st.nextToken(); //qdesc
	    		temp5 = st.nextToken(); //imagename
	    		stmt.setString(1, temp3); 
	    		stmt.setString(2, temp4);
	    		stmt.setString(3, temp5);
	    		stmt.setString(4, temp1);
	    		stmt.executeUpdate();
	    	}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	}
    }
    
    private void insertData() {
    	String labels = req.getParameter("labels");
    	String questions = req.getParameter("questions");
    	String lang = req.getParameter("lang");
    	System.out.println("lang:"+lang);
    	System.out.println("labels:"+labels);	    	
    	System.out.println("questions:"+questions);
    	try {
    		con = dataSource.getConnection();
    		StringTokenizer st = null;
	    	String labelInsert = "insert into labels (lang, labelkey, labelvalue) values (?,?,?)";
	    	stmt = con.prepareStatement(labelInsert);
	    	StringTokenizer labelsToken = new StringTokenizer(labels, "|");
	    	while(labelsToken.hasMoreElements()) {
	    		st = new StringTokenizer(labelsToken.nextToken(), ":");
	    		stmt.setString(1, lang);
	    		stmt.setString(2, st.nextToken());
	    		stmt.setString(3, st.nextToken());
		    	stmt.executeUpdate();
	    	}
	    	
	    	String questionInsert = "insert into questions (qtype, qtext, qdesc, imagename, lang) value (?,?,?,?,?)";
	    	stmt = con.prepareStatement(questionInsert);
	    	StringTokenizer qToken = new StringTokenizer(questions, "|");
	    	while(qToken.hasMoreElements()) {
	    		st = new StringTokenizer(qToken.nextToken(), ":");
	    		//id:section:question:desc:imageName
	    		st.nextToken(); //id avoid
	    		stmt.setString(1, st.nextToken()); 
	    		stmt.setString(2, st.nextToken());
	    		stmt.setString(3, st.nextToken());
	    		stmt.setString(4, st.nextToken());
	    		stmt.setString(5, lang);
	    		stmt.executeUpdate();
	    	}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	}
    }
    
    private String nullCheck(String value) {
    	if(value == null || value.length() == 0) {
    		return "";
    	} else {
    		return value;
    	}
    }
    
    private boolean getData(String lang) {
    	boolean value = false;
    	try {
    		con = dataSource.getConnection();
    		stmt = con.prepareStatement("select * from labels where lang = ?");
    		stmt.setString(1, lang);
    		ResultSet rs = stmt.executeQuery();
    		if(rs.next()) {
    			value = true;
    		}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();
    	}
    	return value;
    }
}


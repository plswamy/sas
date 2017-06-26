
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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

@Controller
public class SASController {

	@Autowired
	DataSource dataSource;
	
	@Autowired
	private HttpServletRequest req;

	@Autowired
	private HttpServletResponse res;
		
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
	  req.setAttribute("questions", getQuestions(null));
	  req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", null));
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
		String score = req.getParameter("score1");
		String user = req.getParameter("username1");
		document.getRootElement().getChild("data").getChild("main").getChild("score").setText(score);
		document.getRootElement().getChild("data").getChild("main").getChild("user").setText(user);
		System.out.println("root element"+document.getRootElement().getChild("data").getChild("main").getChildText("score"));
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
    
    public Hashtable<String, List<Question>> getQuestions(String lang1) {
    	String lang = req.getParameter("lang");
    	System.out.println("lang from parameter...:"+lang);
		if(lang == null || lang.length() ==0) {
			lang = lang1;
		}
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
    
    public Hashtable<String, String> getData(String table, String cKey, String cValue, String lang1) {
    	String lang = req.getParameter("lang");
    	System.out.println("lang from parameter...:"+lang);
		if(lang == null || lang.length() == 0) {
			lang = lang1;
		}
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
    		uploadFiles();
    		String lang = req.getParameter("lang");
    		if(nullCheck(lang).length() == 0 || lang.equals("en")) {
    			lang = "english";
    		}
    		if(lang.equals("english")) {
    			updateEnglishData();
    		} else {
    			boolean update = getData(lang);
		    	if(update) {
		    		System.out.println("updating data for lang:"+lang);
		    		updateData();
		    	} else {
		    		System.out.println("inserting data for lang:"+lang);
		    		insertData();			    	
		    	}
    		}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();
    	}
    }
    
    private void uploadFiles() {
    	try {
	        // location to store file uploaded
	        String UPLOAD_DIRECTORY = "support\\img\\resourceFiles\\123\\";
	       
	         // checks if the request actually contains upload file
	        if (!ServletFileUpload.isMultipartContent(req)) {
	            // if not, we stop here
	            PrintWriter writer = res.getWriter();
	            writer.println("Error: Form must has enctype=multipart/form-data.");
	            writer.flush();
	            return;
	        }
	     
	        // configures upload settings
	        DiskFileItemFactory factory = new DiskFileItemFactory();
	        factory.setRepository(new File(System.getProperty("java.io.tmpdir"))); 
	        ServletFileUpload upload = new ServletFileUpload(factory);
	        String realPath = req.getRealPath("/");
	        String uploadPath = realPath + File.separator + UPLOAD_DIRECTORY;
	        File uploadDir = new File(uploadPath);
	        if (!uploadDir.exists()) {
	            uploadDir.mkdir();
	        }
        
            // parses the request's content to extract file data
            @SuppressWarnings("unchecked")
            List<FileItem> formItems = upload.parseRequest(req);

            if (formItems != null && formItems.size() > 0) {
                // iterates over form's fields
                for (FileItem item : formItems) {
                    // processes only fields that are not form fields
                    if (!item.isFormField() && !item.getName().equals("")) {
                        String fileName = new File(item.getName()).getName();
                        String filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        // saves the file on disk
                        item.write(storeFile);
                        System.out.println("filename uploaded...:"+fileName);
                    }
                }
            }
        } catch (Exception ex) {
            System.out.println("There was an error: " + ex.getMessage());
        }
    }
    
    private void updateEnglishData() {
    	String labels = req.getParameter("labels");
    	String questions = req.getParameter("questions");
    	String lang = req.getParameter("lang");
    	String deletedquestions = req.getParameter("deletedquestions");
    	System.out.println("lang:"+lang);
    	System.out.println("labels:"+labels);	    	
    	System.out.println("questions:"+questions);
    	System.out.println("deletedquestions:"+deletedquestions);
    	PreparedStatement pstmt = null;
    	try {
    		String temp1 = null;
    		String temp2 = null;
    		String temp3 = null;
    		String temp4 = null;
    		String temp5 = null;
			List<String> langs = getLangs();
			
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
	    	String questionEnglishInsert = "insert into questions (qtype, qtext, qdesc, imagename, lang, pqid) value (?,?,?,?,?,?)";
	    	stmt = con.prepareStatement(questionInsert);
	    	pstmt = con.prepareStatement(questionEnglishInsert);
	    	StringTokenizer qToken = new StringTokenizer(questions, "|");
	    	String eqid = null;
	    	while(qToken.hasMoreElements()) {
	    		st = new StringTokenizer(qToken.nextToken(), ":");
	    		//id:section:question:desc:imageName
	    		temp1 = st.nextToken(); //id
	    		temp2 = st.nextToken(); //qtype
	    		temp3 = st.nextToken(); //qtext
	    		temp4 = st.nextToken(); //qdesc
	    		if(st.countTokens() > 0) {
	    			temp5 = st.nextToken(); //imagename
	    		} else {
	    			temp5 = "plan-1.png";	// TODO
	    			temp1 = null;
	    		}
	    		if(nullCheck(temp1).length() > 0) {
		    		stmt.setString(1, temp3); 
		    		stmt.setString(2, temp4);
		    		stmt.setString(3, temp5);
		    		stmt.setString(4, temp1);
		    		stmt.executeUpdate();
	    		} else {
	    			pstmt.setString(1, temp2);
	    			pstmt.setString(2, temp3);
	    			pstmt.setString(3, temp4);
	    			pstmt.setString(4, temp5);
	    			pstmt.setString(5, "english");
	    			pstmt.setString(6, null);
	    			pstmt.executeUpdate();
	    			eqid = getEnglishQId(temp2, temp3, temp4, temp5);
	    			for(int i=0; i < langs.size(); i++) {
	    				System.out.println("inserting question for the language: "+langs.get(i));
	    				pstmt.setString(5, langs.get(i));
	    				pstmt.setString(6, eqid);
	    				pstmt.executeUpdate();
	    			}
	    		}
	    	}
	    	//deletedquestions = deletedquestions.replaceAll("|", ",");
	    	if(deletedquestions != null && deletedquestions.length() > 1) {
		    	deletedquestions = deletedquestions.substring(1);
		    	System.out.print(deletedquestions);
		    	stmt = con.prepareStatement("delete from questions where id in ("+deletedquestions+")");
		    	stmt.executeUpdate();
		    	stmt = con.prepareStatement("delete from questions where pqid in ("+deletedquestions+")");
		    	stmt.executeUpdate();
	    	}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();
    		try { 
    			if(pstmt != null) pstmt.close();
    		} catch(Exception exp) { }
    	}
    }
    
    private String getEnglishQId(String qtype, String qtext, String qdesc, String imagename) {
    	String returnValue = null;
    	Connection con1 = null;
    	PreparedStatement pstmt1 = null;
    	try {
    		String sql = "select id from questions where qtype = ? and qtext = ? and qdesc = ? and imagename = ? and lang = ?";
    		con1 = dataSource.getConnection();
			pstmt1 = con.prepareStatement(sql);
			pstmt1.setString(1, qtype);
			pstmt1.setString(2, qtext);
			pstmt1.setString(3, qdesc);
			pstmt1.setString(4, imagename);
			pstmt1.setString(5, "english");
			ResultSet rs = pstmt1.executeQuery();
			if(rs.next()) {
				returnValue = rs.getString(1);
			}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		try {
    			if(con1 != null) con1.close();
    			if(pstmt1 != null) pstmt1.close();
    		} catch(Exception exp) {
    			exp.printStackTrace();
    		}
    	}
    	return returnValue;
    }
    
    private List<String> getLangs() {
    	List<String> list = new ArrayList<String>();
    	String temp = null;
    	try {
			String sql = "select distinct(lang) from questions;";			
			con = dataSource.getConnection();
			stmt = con.prepareStatement(sql);
			System.out.println("sql stmt for lang....:"+sql);
			ResultSet rs = stmt.executeQuery();
			while(rs.next()) {
				temp = rs.getString(1);
				if(temp!= null && !temp.equalsIgnoreCase("english")) {
					list.add(rs.getString(1));
				}
			}
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	} finally {
    		close();
    	}
    	return list;
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
	    		System.out.println("st token length....:"+st.countTokens());
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
	    	
	    	String questionInsert = "insert into questions (qtype, qtext, qdesc, imagename, pqid, lang) value (?,?,?,?,?,?)";
	    	stmt = con.prepareStatement(questionInsert);
	    	StringTokenizer qToken = new StringTokenizer(questions, "|");
	    	while(qToken.hasMoreElements()) {
	    		st = new StringTokenizer(qToken.nextToken(), ":");
	    		//id:section:question:desc:imageName
	    		//st.nextToken(); //id avoid
	    		stmt.setString(5, st.nextToken()); 
	    		stmt.setString(1, st.nextToken()); 
	    		stmt.setString(2, st.nextToken());
	    		stmt.setString(3, st.nextToken());
	    		stmt.setString(4, st.nextToken());
	    		stmt.setString(6, lang);
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


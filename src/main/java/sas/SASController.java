
package sas;
import javax.servlet.http.HttpServletRequest;
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

import java.sql.*;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
@Controller
public class SASController {

	@Autowired
	DataSource dataSource;
	
	@Autowired
	private HttpServletRequest req;
	
  @RequestMapping("/helloworld")
  public ModelAndView hello(ModelMap model,Principal principal) {

    String loggedInUserName=principal.getName();

    return new ModelAndView("hello", "userName", loggedInUserName);
  }

  @PreAuthorize("hasRole('ROLE_ADMIN')")
  @RequestMapping("/admin")
  public ModelAndView helloAdmin(ModelMap model,Principal principal) {

    String loggedInUserName=principal.getName();

    return new ModelAndView("admin", "userName", loggedInUserName);
  }

  @RequestMapping("/normal-user")
  public ModelAndView helloNormalUser(ModelMap model,Principal principal) {

    String loggedInUserName=principal.getName();

    return new ModelAndView("normal_user", "userName", loggedInUserName);
  }

  @RequestMapping(value="/login", method = RequestMethod.GET)
  public String login(ModelMap model) {

    return "login";

  }

  @RequestMapping(value="/survey", method = RequestMethod.POST)
  public String survey(ModelMap model) {

    return "report";

  }

  @RequestMapping(value="/survey", method = RequestMethod.GET)
  public String surveyGet(ModelMap model) {
	System.out.println("survey get called");
	req.setAttribute("questions", getQuestions());
    return "survey";

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
		String pdfFileName = "C:\\chvsr\\cmsedge\\sas1\\pdf\\pdf5.pdf";
		String xslFileName = "C:\\chvsr\\cmsedge\\sas1\\pdf\\cmsedgexsl_lak.xsl";		
		String xmlFileName = "C:\\chvsr\\cmsedge\\sas1\\pdf\\travel_lak.xml";		
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
    
    public Hashtable<String, List<Question>> getQuestions() {
    	Hashtable<String, List<Question>> hs = new Hashtable<String, List<Question>>();
    	List<Question> list = null;
    	Question q = null;
    	try {
    		Connection con = dataSource.getConnection();
    		Statement stmt = con.createStatement();
    		ResultSet rs = stmt.executeQuery("select * from questions order by id");
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
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	}
    	return hs;
    }
    
    private void loadData() {
  	  	req.setAttribute("labels", getLabels());
  	  	
  	  	// load country list
  	  	// load business industry
  	  	// load state
    }
    
    public Hashtable<String, String> getLabels() {
    	Hashtable<String, String> hs = new Hashtable<String, String>();
    	try {
    		Connection con = dataSource.getConnection();
    		Statement stmt = con.createStatement();
    		ResultSet rs = stmt.executeQuery("select * from labels order by id");
    		while(rs.next()) 
    		{
    			hs.put(rs.getString("labelkey"), rs.getString("labelvalue"));
    		}    		
    	} catch(Exception exp) {
    		exp.printStackTrace();
    	}
    	return hs;
    }
}


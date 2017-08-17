package sas;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import org.jdom.Element;

import java.security.Principal;

import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PropertiesLoaderUtils;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import sas.bean.Question;
import sas.bean.Answer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;

@Controller
public class SASController {
	private static final Logger LOGGER = LoggerFactory.getLogger(SASController.class);
	@Autowired
	DataSource dataSource;

	@Autowired
	private HttpServletRequest req;

	@Autowired
	private HttpServletResponse res;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private RequestMappingHandlerMapping requestMappingHandlerMapping;

	@Autowired
	private HttpSession session;

	Connection con = null;
	PreparedStatement stmt = null;

	@RequestMapping("/helloworld")
	public ModelAndView hello(ModelMap model, Principal principal) {

		String loggedInUserName = principal.getName();

		return new ModelAndView("hello", "userName", loggedInUserName);
	}

	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@RequestMapping("/admin")
	public ModelAndView helloAdmin(ModelMap model, Principal principal) {
		System.out.println("helloAdmin called");
		String requestedLang = req.getParameter("language");
		session.setAttribute("language", requestedLang);
		System.out.println("requested Lang from page is :" + requestedLang);
		String loggedInUserName = principal.getName();
		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", requestedLang));
		req.setAttribute("questions", getQuestions(requestedLang));
		req.setAttribute("langList", getLangs());
		req.setAttribute("userformsfields", getFormFields(requestedLang));
		if (nullCheck(requestedLang).length() > 0) {
			req.setAttribute("language", requestedLang);
		}
		return new ModelAndView("admin", "userName", loggedInUserName);
	}

	@RequestMapping("/normal-user")
	public ModelAndView helloNormalUser(ModelMap model, Principal principal) {
		String loggedInUserName = principal.getName();
		return new ModelAndView("normal_user", "userName", loggedInUserName);
	}

	@RequestMapping(value = "/hello", method = RequestMethod.GET)
	public String hello(ModelMap model) {
		System.out.println("hello called");
		loadData();
		return "index";

	}

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(ModelMap model) {

		return "login";

	}

	@RequestMapping(value = "/survey", method = RequestMethod.GET)
	public String surveyGet(ModelMap model) {
		String lang = (String) session.getAttribute("language");
		if (lang == null)
			lang = req.getParameter("language");
		System.out.println("survey get called....:" + lang);
		req.setAttribute("questions", getQuestions(lang));
		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", lang));
		// req.setAttribute("answertypes", getData("answers", "answertype",
		// "answertypevalue"));
		return "survey";
	}

	@RequestMapping(value = "/survey", method = RequestMethod.POST)
	public String survey(ModelMap model, HttpSession session, HttpServletRequest request) {
		System.out.println("survey post called....");
		System.out.println(
				"ctl00$ContentPlaceHolder1$tbxLastName ===" + model.get("ctl00$ContentPlaceHolder1$tbxLastName"));
		System.out.println("request getParameter ====" + request.getParameter("ctl00$ContentPlaceHolder1$tbxLastName"));
		String lang = (String) session.getAttribute("language");
		if (lang == null)
			lang = req.getParameter("language");
		req.setAttribute("questions", getQuestions(lang));
		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", lang));
		// req.setAttribute("answertypes", getData("answers", "answertype",
		// "answertypevalue"));
		return "report";

	}

	@RequestMapping(value = "/report", method = RequestMethod.POST)
	public String postReport(ModelMap model) throws IOException {
		System.out.println("report post called....");
		System.out.println("email ....:" + req.getParameter("f4"));
		saveUser();
		saveUserResponse();
		// postEloqua();
		return "report";
	}

	@RequestMapping(value = "/report", method = RequestMethod.GET)
	public String getReport(ModelMap model) {
		System.out.println("report get called....");
		String lang = (String) session.getAttribute("language");
		if (lang == null)
			lang = req.getParameter("language");
		String userId = req.getParameter("userid");
		if (nullCheck(userId).length() > 0) {
			req.setAttribute("questions", getQuestions(null));
			req.setAttribute("answers", getAnswers(userId));
			req.setAttribute("userdata", getUserInfo(userId));
		}
		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", lang));
		return "report";

	}

	@RequestMapping(value = "/admin", method = RequestMethod.POST)
	public String postAdmin(ModelMap model) {
		System.out.println("admin post called....");
		String requestedLang = req.getParameter("language");
		session.setAttribute("language", requestedLang);
		saveLangData();

		System.out.println("requested Lang from page is :" + requestedLang);
		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", requestedLang));
		req.setAttribute("questions", getQuestions(requestedLang));
		req.setAttribute("langList", getLangs());
		req.setAttribute("userformsfields", getFormFields(requestedLang));
		if (nullCheck(requestedLang).length() > 0) {
			req.setAttribute("language", requestedLang);
		}
		return "admin";
	}

	@RequestMapping(value = "/home", method = RequestMethod.POST)
	public String home(ModelMap model) {
		System.out.println("home called");
		return "survey";

	}

	@RequestMapping(value = "/", method = RequestMethod.POST)
	public String home1(ModelMap model) {
		System.out.println("home1 called");
		return "survey";
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String homeGet1(ModelMap model) {
		System.out.println("homeGet1");
		loadData();
		return "index";

	}

	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public String homeGet(ModelMap model) {
		System.out.println("homeGet");
		loadData();
		return "index";

	}

	// @RequestMapping(value = "/uploadImage/spiderweb", method =
	// RequestMethod.POST)
	// public String postAdmin(@RequestParam("file_upload") MultipartFile file
	// ){
	// System.out.println("admin post called....");
	// System.out.println(file.getOriginalFilename());
	// try {
	// Files.copy(file.getInputStream(),Paths.get("E:/"+file.getOriginalFilename()));
	// } catch (IOException e) {
	// System.out.println("error in uploading"+e);
	// e.printStackTrace();
	// }
	// return "admin";
	// }
	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/image", method = RequestMethod.POST)
	@ResponseBody
	public String printImage(ModelMap model) throws IOException {
		String pdfFileName = null;
		String picture = req.getParameter("picture");
		String fileName = req.getParameter("filename");
		if (picture != null) {
			String base64 = picture.split("[,]")[1];
			byte[] aByteArray = Base64.decodeBase64(base64.getBytes());
			BufferedImage bufferedImage;
			try {
				bufferedImage = ImageIO.read(new ByteArrayInputStream(aByteArray));
				BufferedImage newBufferedImage = new BufferedImage(bufferedImage.getWidth(), bufferedImage.getHeight(),
						BufferedImage.TYPE_INT_RGB);
				newBufferedImage.createGraphics().drawImage(bufferedImage, 0, 0, Color.WHITE, null);
				String realPath = req.getRealPath("/");
				ImageIO.write(newBufferedImage, "jpg", new File(realPath + "support/img/uploadedImages/" + fileName));

				System.out.println(fileName + " image saved");
				pdfFileName = generatePDF();
				String scoreInfo = req.getParameter("scoreinfo");
				StringTokenizer st = new StringTokenizer(scoreInfo, "|");
				String score = st.nextToken();
				String img = st.nextToken();
				String user = st.nextToken();
				String pdfRealPath = realPath + "pdf/" + pdfFileName;
				System.out.println("pdfRealPath " + pdfRealPath);
				if (pdfFileName != null) {
					try {
						notificationService.sendNotificaitoin(pdfRealPath, scoreInfo);

					} catch (Exception e) {
						LOGGER.error("can not able to send mail.", e);
						e.printStackTrace();
					}
					postEloqua(user, pdfRealPath);
				}

			} catch (IOException e) {
				LOGGER.error("can not able to upload image.", e);
				e.printStackTrace();
			}
		}
		return pdfFileName;
	}

	@RequestMapping(value = "/print", method = RequestMethod.GET)
	public String printGet(ModelMap model) {
		System.out.println("printGet");
		String pdfFilePath = req.getParameter("pdfFilePath");
		req.setAttribute("pdffile", pdfFilePath);
		/*
		 * String pdfFilePath = generatePDF(); if (pdfFilePath != null) { try {
		 * // sendEmail(pdfFilePath);
		 * //notificationService.sendNotificaitoin(pdfFilePath,
		 * req.getParameter("scoreinfo")); System.out.println("mail sent"); }
		 * catch (Exception e) { LOGGER.error("can not able to send mail.", e);
		 * e.printStackTrace(); }
		 * 
		 * }
		 */
		return "print";
	}

	@SuppressWarnings("deprecation")
	private String generatePDF() {
		String pdfFilePath = null;
		try {
			System.out.println("begin");
			String temp = req.getParameter("scoreinfo");
			StringTokenizer st = new StringTokenizer(temp, "|");
			String score = st.nextToken();
			String img = st.nextToken();
			String userid = st.nextToken();
			String email = st.nextToken();
			String companyName = st.nextToken();
			String imageName = st.nextToken();
			String user = st.nextToken();

			if (st.hasMoreElements()) {
				user = user + " " + st.nextToken();
			}
			Resource resource = new ClassPathResource("/application.properties");
			Properties properties = PropertiesLoaderUtils.loadProperties(resource);
			System.out.println("score..." + score);
			System.out.println("img..." + img);
			img = img.replace("png", "jpg");
			System.out.println("user..." + user);
			long l = System.currentTimeMillis();
			String realPath = req.getRealPath("/");
			System.out.println("realPath:" + realPath);
			String pdfFileName = realPath + "/pdf/pdf" + l + ".pdf";
			pdfFilePath = "pdf" + l + ".pdf";
			req.setAttribute("pdffile", "pdf" + l + ".pdf");
			String xslFileName = realPath + "/xsl/cmsedgexsl.xsl";
			String xmlFileName = realPath + "/xsl/travel.xml";
			String imagePath = realPath + properties.getProperty(SASConstants.IMAGE_PATH);
			String uploadImagePath = realPath + properties.getProperty(SASConstants.UPLOAD_IMAGE_PATH);
			String language = (String) session.getAttribute("language");
			if (nullCheck(language).length() == 0) {
				language = "english";
			}
			Hashtable<String, String> translationConstants = getTranslationConstants(language);
			SAXBuilder builder = new SAXBuilder();
			Document document = builder.build(xmlFileName);
			document.getRootElement().getChild("data").getChild("main").getChild("imgPath").setText(imagePath);
			document.getRootElement().getChild("data").getChild("main").getChild("spiderwebImgPath")
					.setText(uploadImagePath);
			document.getRootElement().getChild("data").getChild("main").getChild("pdf_haading")
					.setText(translationConstants.get(SASConstants.PDF_HEADING));
			document.getRootElement().getChild("data").getChild("main").getChild("pdf_sub_haading")
					.setText(translationConstants.get(SASConstants.PDF_SUB_HEADING));
			document.getRootElement().getChild("data").getChild("main").getChild("pdf_score_text")
					.setText(translationConstants.get(SASConstants.PDF_SCORE_HEADING));
			document.getRootElement().getChild("data").getChild("main").getChild("score").setText(score + "%");
			document.getRootElement().getChild("data").getChild("main").getChild("range").setText(img);
			document.getRootElement().getChild("data").getChild("main").getChild("user").setText(user);
			document.getRootElement().getChild("data").getChild("main").getChild("companyname").setText(companyName);
			document.getRootElement().getChild("data").getChild("main").getChild("spiderwebFileName")
					.setText(imageName);
			document.getRootElement().getChild("data").getChild("main").getChild("desc31")
					.setText(translationConstants.get(SASConstants.PDF_LAST_PARA_HEADING));
			document.getRootElement().getChild("data").getChild("main").getChild("desc32")
					.setText(translationConstants.get(SASConstants.PDF_LAST_PARA1));
			document.getRootElement().getChild("data").getChild("main").getChild("desc33")
					.setText(translationConstants.get(SASConstants.PDF_LAST_PARA2));
			document.getRootElement().getChild("data").getChild("main").getChild("desc34")
					.setText(translationConstants.get(SASConstants.PDF_LAST_PARA3));
			Element main = document.getRootElement().getChild("data").getChild("main");
			getQuestionElement(userid, main);
			System.out.println(
					"root element" + document.getRootElement().getChild("data").getChild("main").getChildText("score"));
			XMLOutputter xmOut = new XMLOutputter(); 
			System.out.println("----" + xmOut.outputString(document));
			Doc2Pdf.start(document, xslFileName, pdfFileName);
			System.out.println("imagePath..." + imagePath);
			System.out.println("uploadImagePath..." + uploadImagePath);
			System.out.println("uploadedImageName..." + imageName);
			System.out.println("score..." + score);
			System.out.println("img..." + img);
			System.out.println("user..." + user);
			System.out.println("end");
		} catch (Exception exp) {
			exp.printStackTrace();
		}
		return pdfFilePath;
	}

	@RequestMapping(value = "/loginError", method = RequestMethod.GET)
	public String loginError(ModelMap model) {
		model.addAttribute("error", "true");
		return "login";
	}

	// for 403 access denied page
	@RequestMapping(value = "/403", method = RequestMethod.GET)
	public ModelAndView accesssDenied(Principal user) {

		ModelAndView model = new ModelAndView();
		if (user != null) {
			model.addObject("msg", "Hi " + user.getName() + ", You can not access this page!");
		} else {
			model.addObject("msg", "You can not access this page!");
		}

		model.setViewName("403");
		return model;
	}

	@RequestMapping(value = "*", method = RequestMethod.GET)
	public String anyPath() {

		System.out.println("request path is : " + req.getServletPath());
		System.out.println("all end points in this controller : \n");
		// for(HandlerMethod endPoint :
		// requestMappingHandlerMapping.getHandlerMethods().values()) {
		// System.out.println(endPoint. + "\n");
		// }
		List<String> langs = getLangs();
		String requestedLanguage = req.getServletPath().substring(1);
		for (String language : langs) {
			if (requestedLanguage.equals(language)) {
				session.setAttribute("language", requestedLanguage);
				req.setAttribute("language", requestedLanguage);
				for (RequestMappingInfo info : requestMappingHandlerMapping.getHandlerMethods().keySet()) {
					for (String urlPattern : info.getPatternsCondition().getPatterns()) {
						if (req.getServletPath().equals(urlPattern)) {
							System.out.println(urlPattern.substring(1));
							return urlPattern.substring(1);
						}
					}
				}
				break;
			}
		}
		return "login";
	}
	// @RequestMapping(value = "/404", method = RequestMethod.GET)
	// public ModelAndView noResource(Principal user) {
	// ModelAndView model = new ModelAndView();
	// if (user != null) {
	// model.addObject("msg", "Hi " + user.getName() + ", You can not access
	// this page!");
	// } else {
	// model.addObject("msg", "You can not access this page!");
	// }
	// System.out.println("requested for " + req.getRequestURL());
	// model.setViewName("404");
	// return model;
	// }

	@ExceptionHandler(Exception.class)
	public ModelAndView handleError(HttpServletRequest req, Exception ex) {
		LOGGER.error("Request: " + req.getRequestURL() + " raised " + ex);

		ModelAndView mav = new ModelAndView();
		mav.addObject("exception", ex);
		mav.addObject("url", req.getRequestURL());
		mav.setViewName("error");
		return mav;
	}

	public Hashtable<String, List<Question>> getQuestions(String lang) {
		System.out.println("getQuestions method called with lang: " + lang);
		Hashtable<String, List<Question>> hs = new Hashtable<String, List<Question>>();
		List<Question> list = null;
		Question q = null;
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement("select * from questions where lang = ? order by qorder");
			if (nullCheck(lang).length() == 0 || lang.equals("en")) {
				lang = "english";
			}
			stmt.setString(1, lang);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				q = new Question();
				q.setId(rs.getString("id"));
				q.setType(rs.getString("qtype"));
				q.setImageName(rs.getString("imagename"));
				q.setText(rs.getString("qtext"));
				q.setDesc(rs.getString("qdesc"));
				q.setLang(rs.getString("lang"));
				q.setQorder(rs.getString("qorder"));
				q.setSubtype(rs.getString("qsubtype"));
				list = hs.get(q.getType());
				if (list == null) {
					list = new ArrayList<Question>();
				}
				list.add(q);
				hs.put(q.getType(), list);
			}
			if (hs.size() == 0) {
				hs = getQuestions("english");
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
		return hs;
	}

	public Hashtable<String, String> getAnswers(String userid) {
		System.out.println("getAnswers for userid : " + userid);
		Hashtable<String, String> hs = new Hashtable<String, String>();
		Answer q = null;
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement("select * from userresponse where userid = ?");
			if (nullCheck(userid).length() == 0) {
				// error handling here.
			}
			stmt.setString(1, userid);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				q = new Answer();

				q.setId(rs.getString("id"));
				q.setUserid(rs.getString("userid"));
				q.setQid(rs.getString("qid"));
				q.setQresponse(rs.getString("qresponse"));

				hs.put(q.getQid(), q.getQresponse());
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
		return hs;
	}

	/*
	 * public List<Question> getQuestionsAsList() { List<Question> list = new
	 * ArrayList<Question>(); Question q = null; try { con =
	 * dataSource.getConnection(); stmt =
	 * con.prepareStatement("select * from questions order by id"); ResultSet rs
	 * = stmt.executeQuery(); while(rs.next()) { q = new Question();
	 * q.setId(rs.getString("id")); q.setType(rs.getString("qtype"));
	 * q.setImageName(rs.getString("imagename"));
	 * q.setText(rs.getString("qtext")); q.setDesc(rs.getString("qdesc"));
	 * q.setLang(rs.getString("lang")); list.add(q); } } catch(Exception exp) {
	 * exp.printStackTrace(); } finally { close(); } return list; }
	 */

	private void loadData() {
		System.out.println("loadData called ...");
		String lang = (String) session.getAttribute("language");
		if (lang == null)
			lang = req.getParameter("language");

		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", lang));
		req.setAttribute("businessindustry", getData("businessindustry", "optkey", "optvalue", lang));
		req.setAttribute("country", getData("country", "optkey", "optvalue", lang));
		req.setAttribute("userformfields", getFormFields(lang));
		loadUserSelectionData(lang);
		// req.setAttribute("labels", getData("labels", "labelkey",
		// "labelvalue"));

		// load country list
		// load business industry
		// load state
	}

	public Hashtable<String, String> getData(String table, String cKey, String cValue, String lang) {
		System.out.println("getData called with lang:" + lang);
		Hashtable<String, String> hs = new Hashtable<String, String>();
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement("select * from " + table + " where lang = ? order by id");
			if (nullCheck(lang).length() == 0 || lang.equals("en")) {
				lang = "english";
			}
			stmt.setString(1, lang);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				hs.put(rs.getString(cKey), rs.getString(cValue));
			}
			if (hs.size() == 0) {
				hs = getData(table, cKey, cValue, "english");
			}
		} catch (Exception exp) {
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
			stmt = con.prepareStatement(
					"insert into registrationinfo (f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, lang) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			// System.out.println("email
			// ============================================== : " +
			// req.getParameter("f4"));
			stmt.setString(1, nullCheck(req.getParameter("f1")));
			stmt.setString(2, nullCheck(req.getParameter("f2")));
			stmt.setString(3, nullCheck(req.getParameter("f3")));
			stmt.setString(4, nullCheck(req.getParameter("f4")));
			stmt.setString(5, nullCheck(req.getParameter("f5")));
			stmt.setString(6, nullCheck(req.getParameter("f6")));
			stmt.setString(7, nullCheck(req.getParameter("f7")));
			stmt.setString(8, nullCheck(req.getParameter("f8")));
			stmt.setString(9, nullCheck(req.getParameter("f9")));
			stmt.setString(10, nullCheck(req.getParameter("f10")));
			stmt.setString(11, nullCheck(req.getParameter("f11")));
			stmt.setString(12, nullCheck(req.getParameter("f12")));
			stmt.setString(13, nullCheck(req.getParameter("f13")));
			stmt.setString(14, nullCheck(req.getParameter("f14")));
			stmt.setString(15, nullCheck(req.getParameter("f15")));
			stmt.setString(16, nullCheck(req.getParameter("f16")));
			stmt.setString(17, "english");
			stmt.executeUpdate();
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	private void close() {
		try {
			if (stmt != null)
				stmt.close();
			if (con != null)
				con.close();
		} catch (Exception exp) {
			exp.printStackTrace();
		}
	}

	private void saveUserResponse() {
		System.out.println("save user response called");
		String userid = getUserId(nullCheck(req.getParameter("f4")));
		req.setAttribute("userid", userid);
		/* List<Question> list = getQuestionsAsList(); */
		String userRes = nullCheck(req.getParameter("userResponse"));
		if (userRes.length() > 0) {
			StringTokenizer st = new StringTokenizer(userRes, "|");
			String temp = null;
			StringTokenizer tempst = null;
			String sql = "insert into userresponse (userid, qid, qresponse) values (?,?,?)";
			try {
				con = dataSource.getConnection();
				stmt = con.prepareStatement(sql);
				while (st.hasMoreElements()) {
					temp = st.nextToken();
					tempst = new StringTokenizer(temp, ":");
					stmt.setString(1, userid);
					stmt.setString(2, tempst.nextToken());
					stmt.setString(3, tempst.nextToken());
					stmt.executeUpdate();
				}
			} catch (Exception exp) {
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
			stmt = con.prepareStatement("select id from registrationinfo where f4='" + key + "' order by id desc");
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				id = rs.getString(1);
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
		return id;
	}

	private List<String> getUserInfo(String userId) {
		List<String> list = new ArrayList<String>();
		String temp = null;
		try {
			String sql = "select f1, f2, f4 from registrationinfo where id=" + userId;
			con = dataSource.getConnection();
			stmt = con.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				if (list == null) {
					list = new ArrayList<String>();
				}
				list.add(rs.getString(1));
				list.add(rs.getString(2));
				list.add(rs.getString(3));
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
		return list;
	}

	private void saveLangData() {
		try {
			uploadFiles();
			String lang = req.getParameter("lang");
			if (lang == null) {
				lang = (String) session.getAttribute("language");
			}
			if (nullCheck(lang).length() == 0 || lang.equals("en") || lang.equals("master")) {
				lang = "english";
			}
			if (lang.equals("english")) {
				updateEnglishData();
			} else {
				boolean update = getData(lang);
				if (update) {
					System.out.println("updating data for lang:" + lang);
					updateData();
				} else {
					System.out.println("inserting data for lang:" + lang);
					insertData();
				}
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	@SuppressWarnings("deprecation")
	private void uploadFiles() {
		try {

			String UPLOAD_DIRECTORY = "support\\img\\resourceFiles\\123\\";
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
			System.out.println("formItems.....:" + formItems);
			System.out.println("formItems.....:" + formItems.size());
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
						System.out.println("filename uploaded...:" + fileName);
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
		String userformsfields = req.getParameter("userformsfields");
		String lang = req.getParameter("lang");
		if (lang == null) {
			session.getAttribute("language");
		}
		if (nullCheck(lang).length() == 0 || lang.equals("en")) {
			lang = "english";
		}
		String deletedquestions = req.getParameter("deletedquestions");
		System.out.println("lang:" + lang);
		System.out.println("labels:" + labels);
		System.out.println("questions:" + questions);
		System.out.println("deletedquestions:" + deletedquestions);
		System.out.println("userformsfields:" + userformsfields);
		updateFormFields(userformsfields);
		PreparedStatement pstmt = null;
		PreparedStatement ustmt = null;
		try {
			String temp1 = null;
			String temp2 = null;
			String temp3 = null;
			String temp4 = null;
			String temp5 = null;
			String temp6 = null;
			String temp7 = null;
			List<String> langs = getLangs();

			con = dataSource.getConnection();
			StringTokenizer st = null;
			// update labels set labelvalue='test' where labelkey='welcomeDesc'
			// and lang='en1';
			String labelInsert = "update labels set labelvalue=? where labelkey=? and lang=?";
			stmt = con.prepareStatement(labelInsert);
			StringTokenizer labelsToken = new StringTokenizer(labels, "|");
			while (labelsToken.hasMoreElements()) {
				st = new StringTokenizer(labelsToken.nextToken(), ":");
				// labelKey:labelvalue
				temp1 = st.nextToken();
				temp2 = st.nextToken();
				stmt.setString(1, temp2);
				stmt.setString(2, temp1);
				stmt.setString(3, lang);
				stmt.executeUpdate();
			}

			String questionInsert = "update questions set qtext = ?, qdesc = ?, imagename = ?, qsubtype = ?, qorder = ? where id = ?";
			String questionEnglishInsert = "insert into questions (qtype, qtext, qdesc, imagename, lang, pqid, qsubtype, qorder) value (?,?,?,?,?,?,?,?)";
			String questionUpdate = "update questions set qorder = ? where pqid= ?";
			stmt = con.prepareStatement(questionInsert);
			pstmt = con.prepareStatement(questionEnglishInsert);
			ustmt = con.prepareStatement(questionUpdate);
			StringTokenizer qToken = new StringTokenizer(questions, "|");
			String eqid = null;
			while (qToken.hasMoreElements()) {
				st = new StringTokenizer(qToken.nextToken(), ":");
				// id:section:question:subsection:desc:imageName:order
				temp1 = st.nextToken(); // id
				temp2 = st.nextToken(); // qtype
				temp3 = st.nextToken(); // qtext
				temp6 = st.nextToken(); // qsubtype
				temp4 = st.nextToken(); // qdesc
				if (st.countTokens() > 0) {
					temp5 = st.nextToken(); // imagename
				} else {
					temp5 = "plan-1.png"; // TODO
					temp1 = null;
				}
				temp7 = st.nextToken(); // order
				if (!nullCheck(temp1).equals("-1")) {
					stmt.setString(1, temp3);
					stmt.setString(2, temp4);
					stmt.setString(3, temp5);
					stmt.setString(4, temp6);
					stmt.setString(5, temp7);
					stmt.setString(6, temp1);
					stmt.executeUpdate();
					ustmt.setString(1, temp7);
					ustmt.setString(2, temp1);
					ustmt.executeUpdate();
				} else {
					pstmt.setString(1, temp2);
					pstmt.setString(2, temp3);
					pstmt.setString(3, temp4);
					pstmt.setString(4, temp5);
					pstmt.setString(5, "english");
					pstmt.setString(6, null);
					pstmt.setString(7, temp6);
					pstmt.setString(8, temp7);
					pstmt.executeUpdate();
					eqid = getEnglishQId(temp2, temp3, temp4, temp5);
					for (int i = 0; i < langs.size(); i++) {
						System.out.println("inserting question for the language: " + langs.get(i));
						pstmt.setString(5, langs.get(i));
						pstmt.setString(6, eqid);
						pstmt.executeUpdate();
					}
				}
			}
			// deletedquestions = deletedquestions.replaceAll("|", ",");
			if (deletedquestions != null && deletedquestions.length() > 1) {
				deletedquestions = deletedquestions.substring(1);
				System.out.print(deletedquestions);
				stmt = con.prepareStatement("delete from questions where id in (" + deletedquestions + ")");
				stmt.executeUpdate();
				stmt = con.prepareStatement("delete from questions where pqid in (" + deletedquestions + ")");
				stmt.executeUpdate();
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
			try {
				if (pstmt != null)
					pstmt.close();
				if (ustmt != null)
					ustmt.close();
			} catch (Exception exp) {
			}
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
			if (rs.next()) {
				returnValue = rs.getString(1);
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			try {
				if (con1 != null)
					con1.close();
				if (pstmt1 != null)
					pstmt1.close();
			} catch (Exception exp) {
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
			System.out.println("sql stmt for lang....:" + sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				temp = rs.getString(1);
				if (temp != null && !temp.equalsIgnoreCase("english")) {
					list.add(rs.getString(1));
				}
			}
		} catch (Exception exp) {
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
		if (lang == null) {
			lang = (String) session.getAttribute("language");
		}
		System.out.println("lang:" + lang);
		System.out.println("labels:" + labels);
		System.out.println("questions:" + questions);
		String userformsfields = req.getParameter("userformsfields");
		System.out.println("userformsfields:" + userformsfields);
		updateFormFields(userformsfields);
		try {
			String temp1 = null;
			String temp2 = null;
			String temp3 = null;
			String temp4 = null;
			String temp5 = null;
			String temp6 = null;
			String temp7 = null;
			con = dataSource.getConnection();
			StringTokenizer st = null;
			// update labels set labelvalue='test' where labelkey='welcomeDesc'
			// and lang='en1';
			String labelInsert = "update labels set labelvalue=? where labelkey=? and lang=?";
			stmt = con.prepareStatement(labelInsert);
			StringTokenizer labelsToken = new StringTokenizer(labels, "|");
			while (labelsToken.hasMoreElements()) {
				st = new StringTokenizer(labelsToken.nextToken(), ":");
				// labelKey:labelvalue
				temp1 = st.nextToken();
				temp2 = st.nextToken();
				stmt.setString(1, temp2);
				stmt.setString(2, temp1);
				stmt.setString(3, lang);
				stmt.executeUpdate();
			}

			String questionInsert = "update questions set qtext = ?, qdesc = ?, imagename = ?, qsubtype = ?, qorder = ? where id = ?";
			stmt = con.prepareStatement(questionInsert);
			StringTokenizer qToken = new StringTokenizer(questions, "|");
			while (qToken.hasMoreElements()) {
				st = new StringTokenizer(qToken.nextToken(), ":");
				System.out.println("st token length....:" + st.countTokens());
				// id:section:question:desc:imageName
				// id:section:question:subsection:desc:imageName:order
				temp1 = st.nextToken(); // id
				temp2 = st.nextToken(); // qtype
				temp3 = st.nextToken(); // qtext
				temp4 = st.nextToken(); // qsubtype
				temp5 = st.nextToken(); // qdesc
				temp6 = st.nextToken(); // imagename
				temp7 = st.nextToken(); // qorder
				stmt.setString(1, temp3);
				stmt.setString(2, temp5);
				stmt.setString(3, temp6);
				stmt.setString(4, temp4);
				stmt.setString(5, temp7);
				stmt.setString(6, temp1);
				stmt.executeUpdate();
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		}
	}

	private void insertData() {
		String temp = null;
		String labels = req.getParameter("labels");
		String questions = req.getParameter("questions");
		String lang = req.getParameter("lang");
		if (lang == null) {
			lang = (String) session.getAttribute("language");
		}
		System.out.println("lang:" + lang);
		System.out.println("labels:" + labels);
		System.out.println("questions:" + questions);
		String userformsfields = req.getParameter("userformsfields");
		System.out.println("userformsfields:" + userformsfields);
		insertFormFields(userformsfields, lang);
		try {
			con = dataSource.getConnection();
			StringTokenizer st = null;
			String labelInsert = "insert into labels (lang, labelkey, labelvalue) values (?,?,?)";
			stmt = con.prepareStatement(labelInsert);
			StringTokenizer labelsToken = new StringTokenizer(labels, "|");
			while (labelsToken.hasMoreElements()) {
				st = new StringTokenizer(labelsToken.nextToken(), ":");
				stmt.setString(1, lang);
				stmt.setString(2, st.nextToken());
				stmt.setString(3, st.nextToken());
				stmt.executeUpdate();
			}

			// String questionInsert = "insert into questions (qtype, qtext,
			// qdesc, imagename, pqid, lang) value (?,?,?,?,?,?)";
			String questionInsert = "insert into questions (qtype, qtext, qdesc, imagename, lang, pqid, qsubtype, qorder) value (?,?,?,?,?,?,?,?)";
			stmt = con.prepareStatement(questionInsert);
			StringTokenizer qToken = new StringTokenizer(questions, "|");
			while (qToken.hasMoreElements()) {
				st = new StringTokenizer(qToken.nextToken(), ":");
				// id:section:question:desc:imageName
				// id:section:question:subsection:desc:imageName:order
				temp = st.nextToken(); // id avoid
				stmt.setString(1, st.nextToken()); // qtype
				stmt.setString(2, st.nextToken()); // qtext
				stmt.setString(7, st.nextToken()); // subsection
				stmt.setString(3, st.nextToken()); // qdesc
				stmt.setString(4, st.nextToken()); // imagename
				stmt.setString(5, lang);
				stmt.setString(6, temp); // parentquestion
				stmt.setString(8, st.nextToken());

				stmt.executeUpdate();
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		}
	}

	private String nullCheck(String value) {
		if (value == null || value.length() == 0) {
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
			if (rs.next()) {
				value = true;
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
		return value;
	}

	public Hashtable<String, String> getFormFields(String lang) {
		Hashtable<String, String> hs = new Hashtable<String, String>();
		System.out.println("getFormFields method called with lang: " + lang);
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement("select * from registrationfields where lang = ?");
			if (nullCheck(lang).length() == 0 || lang.equals("en")) {
				lang = "english";
			}
			stmt.setString(1, lang);
			ResultSet rs = stmt.executeQuery();
			String key = null;
			String value = null;
			while (rs.next()) {
				// id:order:type:displayname:required:<<options>>
				value = rs.getString("id");
				value = value + ":" + rs.getString("forder");
				value = value + ":" + rs.getString("fieldtype");
				value = value + ":" + rs.getString("fielddispname");
				value = value + ":" + rs.getString("showflag");
				key = rs.getString("options");
				if (key != null && key.length() > 0) {
					value = value + ":" + key;
				}
				key = rs.getString("fieldname");
				hs.put(key, value);
			}
			if (hs.size() == 0) {
				hs = getFormFields("english");
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}

		return hs;
	}

	private void insertFormFields(String data, String lang) {
		System.out.println("data in insertFormFields....:" + data);

		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement(
					"insert into registrationfields (fieldname, forder, fieldtype, fielddispname, showflag, options, lang) values (?,?,?,?,?,?,?)");
			String st[] = data.split("\\|cmsedge\\|");
			String[] st1 = null;
			String temp1 = null;
			for (int i = 0; i < st.length; i++) {
				temp1 = st[i];
				st1 = st[i].split("\\:cmsedge\\:");
				// fieldname:id:order:type:displayname:required:<<options>>
				stmt.setString(1, st1[0]);
				stmt.setString(2, st1[2]);
				stmt.setString(3, st1[3]);
				stmt.setString(4, st1[4]);
				stmt.setString(5, st1[5]);
				if (st1.length > 6) {
					stmt.setString(6, st1[6]);
				} else {
					stmt.setString(6, null);
				}
				stmt.setString(7, lang);
				stmt.executeUpdate();
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	private void updateFormFields(String data) {
		System.out.println("data in updateformfields....:" + data);

		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement(
					"update registrationfields set forder=?, fieldtype=?, fielddispname=?, showflag=?, options=?  where id=?");
			String st[] = data.split("\\|cmsedge\\|");
			StringTokenizer st1 = null;
			String temp1[] = null;
			String temp = null;
			for (int i = 0; i < st.length; i++) {
				temp1 = st[i].split("\\:cmsedge\\:");
				// fieldname:id:order:type:displayname:required:<<options>>

				temp = temp1[1]; // id
				stmt.setString(1, temp1[2]);
				stmt.setString(2, temp1[3]);
				stmt.setString(3, temp1[4]);
				stmt.setString(4, temp1[5]);
				if (temp1.length > 6) {
					stmt.setString(5, temp1[6]);
				} else {
					stmt.setString(5, null);
				}
				stmt.setString(6, temp);
				stmt.executeUpdate();
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	private void loadUserSelectionData(String lang) {
		System.out.println("loadUserSelectionData called with lang:" + lang);
		Hashtable<String, String> hs = new Hashtable<String, String>();
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement(
					"select fieldname, options from registrationfields where fieldtype = ? and lang = ?");
			stmt.setString(1, "select");
			if (nullCheck(lang).length() == 0 || lang.equals("en")) {
				lang = "english";
			}
			stmt.setString(2, lang);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				hs.put(rs.getString(1), rs.getString(2));
			}
			if (hs.size() > 0) {
				getOptionsData(hs);
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	private void getOptionsData(Hashtable<String, String> hs) {
		try {
			Enumeration<String> keys = hs.keys();
			String key = null;
			String temp1 = null, temp2 = null;
			con = dataSource.getConnection();
			ResultSet rs = null;
			Hashtable data = null;
			while (keys.hasMoreElements()) {
				key = keys.nextElement();
				data = new Hashtable();
				String sql = hs.get(key);
				stmt = con.prepareStatement(sql);
				try {
					rs = stmt.executeQuery();
					while (rs.next()) {
						data.put(rs.getString(1), rs.getString(2));
					}
					req.setAttribute(key, data);
				} catch (Exception exp) {
					exp.printStackTrace();
				}
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	private void getQuestionElement(String userid, Element main) {
		LinkedHashMap<String, List<Question>> hs = new LinkedHashMap<String, List<Question>>();
		try {
			String sql = "select * from questions where id in (select qid from userresponse where qresponse != ? and userid=? order by qid)";
			con = dataSource.getConnection();
			stmt = con.prepareStatement(sql);
			stmt.setString(1, "yes");
			stmt.setString(2, userid);
			ResultSet rs = stmt.executeQuery();
			Question q = null;
			List<Question> list = null;
			while (rs.next()) {
				q = new Question();
				q.setId(rs.getString("id"));
				q.setType(rs.getString("qtype"));
				q.setImageName(rs.getString("imagename"));
				q.setText(rs.getString("qtext"));
				q.setDesc(rs.getString("qdesc"));
				q.setLang(rs.getString("lang"));
				q.setQorder(rs.getString("qorder"));
				q.setSubtype(rs.getString("qsubtype"));
				list = hs.get(q.getType());
				if (list == null) {
					list = new ArrayList<Question>();
				}
				list.add(q);
				hs.put(q.getType(), list);
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}

		try {
			Iterator<String> keys = hs.keySet().iterator();
			List<Question> list = null;
			String key = null;
			Question q = null;
			Element qElem = null;
			Element temp = null;
			Attribute attribute = null;
			int index = 1;
			while (keys.hasNext()) {
				Element planElement = new Element("plan");
				Element title = new Element("title");
				key = keys.next();
				title.setText(key);
				attribute = new Attribute("id", index + "");
				title.setAttribute(attribute);
				System.out.println("key...." + key);
				planElement.addContent(title);
				list = hs.get(key);
				for (int i = 0; i < list.size(); i++) {
					q = list.get(i);
					qElem = new Element("question");
					temp = new Element("title");
					temp.setText("Q" + q.getQorder());
					qElem.addContent(temp);
					temp = new Element("value");
					temp.setText(q.getText());
					qElem.addContent(temp);
					temp = new Element("answer");
					temp.setText(q.getDesc());
					qElem.addContent(temp);
					planElement.addContent(qElem);
				}
				main.addContent(planElement);
				index++;
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		}
	}

	public void postEloqua(String userId, String pdfFilePath) throws IOException {

		try {

			Resource resource = new ClassPathResource("/application.properties");
			Properties properties = PropertiesLoaderUtils.loadProperties(resource);
			String token = properties.getProperty(SASConstants.COMPANY_NAME) + "\\"
					+ properties.getProperty(SASConstants.ELOQUA_USER) + ":"
					+ properties.getProperty(SASConstants.ELOQUA_PWD);
			byte[] encodedBytes = Base64.encodeBase64(token.getBytes());
			String encodedToken = "Basic " + new String(encodedBytes);
			String eloquaUrl = properties.getProperty(SASConstants.ELOQUA_URL_CUSTOM_OBJECT);
			String jsonStr = getData4Eloqua(properties, userId, pdfFilePath);
			System.out.println("eloqua json = " + jsonStr);
			System.out.println("eloqua url = https://secure.p06.eloqua.com/api/REST/2.0/data/customObject/34/instance");
			System.out.println("eloqua url = " + eloquaUrl);
			com.mashape.unirest.http.HttpResponse<String> response = Unirest.post(eloquaUrl)
					.header("authorization", encodedToken).header("content-type", "application/json")
					.header("cache-control", "no-cache").header("postman-token", "6c51d19d-2327-fc92-8218-c8dd22ac35ee")
					.body(jsonStr).asString();
			System.out.println(response.getBody());
		} catch (UnirestException e) {
			e.printStackTrace();
		}
	}

	public String getData4Eloqua(Properties properties, String userId, String pdfFilePath) {
		String jsonStr = null;
		// String userId = (String) req.getAttribute("userid");
		Map<String, String> map = new HashMap<String, String>();
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement(
					"select info.f6, info.f5, info.f7, info.f4, info.f1, info.f2, info.id, info.lang, response.qid, response.qresponse from registrationinfo info, userresponse response where info.id=response.userid and info.id=? ");
			// "select max(response.id), info.f6, info.f5, info.f7, info.f4,
			// info.f1, info.f2, info.id, info.lang, response.qid,
			// response.qresponse from registrationinfo info, userresponse
			// response where info.id=response.userid and info.id=? group by
			// info.f4, response.qid HAVING COUNT(*) > 1");
			stmt.setString(1, userId);
			ResultSet rs = stmt.executeQuery();
			int index = 0;
			while (rs.next()) {
				if (index == 0) {
					map.put(properties.getProperty(SASConstants.LANGUAGE),
							rs.getString("lang") + " " + properties.getProperty(SASConstants.SELF_ASSESSMENT));
					map.put(properties.getProperty(SASConstants.BUSSINESS_INDUSTRY), rs.getString("f6"));
					map.put(properties.getProperty(SASConstants.COMPANY), rs.getString("f5"));
					map.put(properties.getProperty(SASConstants.COUNTRY), rs.getString("f7"));
					map.put(properties.getProperty(SASConstants.EMAIL), rs.getString("f4"));
					map.put(properties.getProperty(SASConstants.FIRST_NAME), rs.getString("f1"));
					map.put(properties.getProperty(SASConstants.LAST_NAME), rs.getString("f2"));
					map.put(properties.getProperty(SASConstants.TITLE), "SME");
					map.put(properties.getProperty(SASConstants.USER_ID), rs.getString("id"));
					map.put(properties.getProperty(SASConstants.QUESTION_ID), rs.getString("qid"));
					map.put(properties.getProperty(SASConstants.QUESTION_RESPONSE), rs.getString("qresponse"));
				} else {
					String qidKey = properties.getProperty(SASConstants.QUESTION_ID);
					String qresponseKey = properties.getProperty(SASConstants.QUESTION_RESPONSE);
					String qid = map.get(qidKey);
					String qresponse = map.get(qresponseKey);
					qid = qid + "," + rs.getString("qid");
					qresponse = qresponse + "," + rs.getString("qresponse");
					map.replace(qidKey, qid);
					map.replace(qresponseKey, qresponse);
				}
				index++;
			}
			jsonStr = generateJson(properties, map);

		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
		return jsonStr;
	}

	public String generateJson(Properties properties, Map<String, String> hs) {
		JSONObject dataset = new JSONObject();
		dataset.put("type", SASConstants.CUSTOM_OBJECT_DATA);
		dataset.put("id", properties.getProperty(SASConstants.CUSTOM_OBJECT_ID));
		JSONArray fieldset = new JSONArray();
		for (String key : hs.keySet()) {
			JSONObject field = new JSONObject();
			field.put("id", key);
			field.put("value", hs.get(key));
			fieldset.put(field);
		}
		dataset.put("fieldValues", fieldset);

		System.out.println(JSONObject.quote(dataset.toString()));

		return dataset.toString();
	}

	public Hashtable<String, String> getTranslationConstants(String language) {
		Hashtable<String, String> translationConstantsTable = new Hashtable<String, String>();
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement(
					"SELECT translation_key, translation_value FROM translation_constants where translation_language=?");
			stmt.setString(1, language);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				translationConstantsTable.put(rs.getString("translation_key"), rs.getString("translation_value"));
			}
		} catch (Exception exp) {
			exp.printStackTrace();
		} finally {
			close();
		}
		return translationConstantsTable;
	}
}

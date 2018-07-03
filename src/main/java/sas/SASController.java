package sas;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import sas.bean.Question;
import sas.bean.Answer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
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
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
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

	/*@Autowired
	private NotificationService notificationService;
	 */
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
		LOGGER.info("helloAdmin called");
		String requestedLang = req.getParameter("language");
		if(requestedLang== null || requestedLang!= null && requestedLang.equals("master"))
			requestedLang = "english";
		else if (nullCheck(requestedLang).length() == 0 || requestedLang.equals("en")) {
			requestedLang = "english";
		}
		session.setAttribute("language", requestedLang);
		LOGGER.info("requested Lang from page is :" + requestedLang);
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
		LOGGER.info("hello called");
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
		LOGGER.info("survey get called....:" + lang);
		req.setAttribute("questions", getQuestions(lang));
		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", lang));
		// req.setAttribute("answertypes", getData("answers", "answertype",
		// "answertypevalue"));
		return "survey";
	}

	@RequestMapping(value = "/survey", method = RequestMethod.POST)
	public String survey(ModelMap model, HttpSession session, HttpServletRequest request) {
		LOGGER.info("survey post called....");
		LOGGER.info(
				"ctl00$ContentPlaceHolder1$tbxLastName ===" + model.get("ctl00$ContentPlaceHolder1$tbxLastName"));
		LOGGER.info("request getParameter ====" + request.getParameter("ctl00$ContentPlaceHolder1$tbxLastName"));
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
		LOGGER.info("report post called....");
		LOGGER.info("email ....:" + req.getParameter("f4"));
		saveUser();
		saveUserResponse();
		String lang = (String) session.getAttribute("language");
		if (lang == null)
			lang = req.getParameter("language");
		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", lang));
		req.setAttribute("language",lang);
		req.setAttribute("responseavg",getResponseAverage(lang));
		// postEloqua();
		return "report";
	}

	@RequestMapping(value = "/report", method = RequestMethod.GET)
	public String getReport(ModelMap model) {
		LOGGER.info("report get called....");
		String lang = (String) session.getAttribute("language");
		if (lang == null)
			lang = req.getParameter("language");
		String userId = req.getParameter("userid");
		if (nullCheck(userId).length() > 0) {
			req.setAttribute("questions", getQuestions(null));
			req.setAttribute("answers", getAnswers(userId));
			req.setAttribute("userdata", getUserInfo(userId));
			//req.setAttribute("responseavg",getResponseAverage(lang));
		}
		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", lang));
		return "report";

	}

	@RequestMapping(value = "/admin", method = RequestMethod.POST)
	/*public String postAdmin(@RequestPart(value = "file_plan_-1", required=false) MultipartFile  planFile, @RequestPart(value = "file_do_-1", required=false) MultipartFile  doFile, @RequestPart(value = "file_check_-1", required=false) MultipartFile  checkFile,
            RedirectAttributes redirectAttributes) {*/
	public String postAdmin(MultipartHttpServletRequest request) {
		 Enumeration<String> en = req.getParameterNames();
		 /*while(en.hasMoreElements()) {
			 System.out.println(en.nextElement());
		 }*/
		Map<String, MultipartFile> fileMap = request.getFileMap();
		LOGGER.info("admin post called....");
		LOGGER.info("=============admin post called=======================");
		saveLangData(fileMap, request);
		String requestedLang = req.getParameter("language");
		session.setAttribute("language", requestedLang);
		LOGGER.info("requested Lang from page is :" + requestedLang);
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
		LOGGER.info("home called");
		return "survey";

	}

	@RequestMapping(value = "/", method = RequestMethod.POST)
	public String home1(ModelMap model) {
		LOGGER.info("home1 called");
		return "survey";
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String homeGet1(ModelMap model) {
		LOGGER.info("homeGet1");
		loadData();
		return "index";

	}

	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public String homeGet(ModelMap model) {
		LOGGER.info("homeGet");
		loadData();
		return "index";

	}

	// @RequestMapping(value = "/uploadImage/spiderweb", method =
	// RequestMethod.POST)
	// public String postAdmin(@RequestParam("file_upload") MultipartFile file
	// ){
	// LOGGER.info("admin post called....");
	// LOGGER.info(file.getOriginalFilename());
	// try {
	// Files.copy(file.getInputStream(),Paths.get("E:/"+file.getOriginalFilename()));
	// } catch (IOException e) {
	// LOGGER.info("error in uploading"+e);
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
		String language = req.getParameter("language");
		if (nullCheck(language).length() == 0) {
			language = "english";
		}
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
				//ImageIO.write(newBufferedImage, "jpg", new File(realPath + "support/img/uploadedImages/" + fileName));
				
				ImageWriter jpgWriter = ImageIO.getImageWritersByFormatName("jpg").next();
				ImageWriteParam jpgWriteParam = jpgWriter.getDefaultWriteParam();
				jpgWriteParam.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
				jpgWriteParam.setCompressionQuality(1.0f);

				jpgWriter.setOutput(ImageIO.createImageOutputStream(new File(realPath + "support/img/uploadedImages/" + fileName)));
				IIOImage outputImage = new IIOImage(newBufferedImage, null, null);
				jpgWriter.write(null, outputImage, jpgWriteParam);
				jpgWriter.dispose();
				
				LOGGER.info(fileName + " image saved");
				pdfFileName = generatePDF(language);
				String scoreInfo = req.getParameter("scoreinfo");
				StringTokenizer st = new StringTokenizer(scoreInfo, "|");
				String score = st.nextToken();
				String img = st.nextToken();
				String user = st.nextToken();
				String pdfRealPath = realPath + "pdf/" + pdfFileName;
				LOGGER.info("pdfRealPath " + pdfRealPath);
				if (pdfFileName != null) {
					try {
						//notificationService.sendNotificaitoin(pdfRealPath, scoreInfo);

					} catch (Exception e) {
						LOGGER.error("can not able to send mail.", e);
						e.printStackTrace();
					}
					postEloqua(user, pdfFileName,language);
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
		LOGGER.info("printGet");
		String pdfFilePath = req.getParameter("pdfFilePath");
		req.setAttribute("pdffile", pdfFilePath);
		/*
		 * String pdfFilePath = generatePDF(); if (pdfFilePath != null) { try {
		 * // sendEmail(pdfFilePath);
		 * //notificationService.sendNotificaitoin(pdfFilePath,
		 * req.getParameter("scoreinfo")); LOGGER.info("mail sent"); }
		 * catch (Exception e) { LOGGER.error("can not able to send mail.", e);
		 * e.printStackTrace(); }
		 * 
		 * }
		 */
		return "print";
	}

	@SuppressWarnings("deprecation")
	private String generatePDF(String language) {
		String pdfFilePath = null;
		try {
			LOGGER.info("begin");
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
			LOGGER.info("score..." + score);
			LOGGER.info("img..." + img);
			img = img.replace("png", "jpg");
			LOGGER.info("user..." + user);
			long l = System.currentTimeMillis();
			String realPath = req.getRealPath("/");
			LOGGER.info("realPath:" + realPath);
			String pdfFileName = realPath + "/pdf/pdf" + l + ".pdf";
			pdfFilePath = "pdf" + l + ".pdf";
			req.setAttribute("pdffile", "pdf" + l + ".pdf");
			String xslFileName = realPath + "/xsl/cmsedgexsl.xsl";
			String xmlFileName = realPath + "/xsl/travel.xml";
			String imagePath = realPath + properties.getProperty(SASConstants.IMAGE_PATH);
			String uploadImagePath = realPath + properties.getProperty(SASConstants.UPLOAD_IMAGE_PATH);
			//String language = (String) session.getAttribute("language");
			if (nullCheck(language).length() == 0) {
				language = "english";
			}
			Hashtable<String, String> translationConstants = getData("labels", "labelkey", "labelvalue", language);
					//getTranslationConstants(language);
			SAXBuilder builder = new SAXBuilder();
			Document document = builder.build(xmlFileName);
			document.getRootElement().getChild("data").getChild("main").getChild("imgPath").setText(imagePath);
			document.getRootElement().getChild("data").getChild("main").getChild("spiderwebImgPath")
					.setText(uploadImagePath);
			document.getRootElement().getChild("data").getChild("main").getChild("pdf_heading")
					.setText(translationConstants.get(SASConstants.PDF_HEADING));
			document.getRootElement().getChild("data").getChild("main").getChild("pdf_sub_haading")
					.setText(translationConstants.get(SASConstants.PDF_SUB_HEADING));
			document.getRootElement().getChild("data").getChild("main").getChild("pdf_score_text")
					.setText(translationConstants.get(SASConstants.PDF_SCORE_HEADING));
			if(translationConstants.containsKey(SASConstants.PDF_SECTION_SUB_HEADING)) {
				String subHeading = translationConstants.get(SASConstants.PDF_SECTION_SUB_HEADING);
				String redColoredString = translationConstants.get(SASConstants.PDF_SECTION_SUB_HEADING_REDTOKEN);
				if(redColoredString !=null && subHeading.indexOf(redColoredString)>-1) {
					String frontPart = subHeading.substring(0, subHeading.indexOf(redColoredString));
					String rearPart = subHeading.substring(subHeading.indexOf(redColoredString)+redColoredString.length());
					document.getRootElement().getChild("data").getChild("main").getChild("pdf_section_sub_heading1")
					.setText(frontPart);
					document.getRootElement().getChild("data").getChild("main").getChild("pdf_section_sub_heading2")
					.setText(redColoredString);
					document.getRootElement().getChild("data").getChild("main").getChild("pdf_section_sub_heading3")
					.setText(rearPart);
				} else {
					document.getRootElement().getChild("data").getChild("main").getChild("pdf_section_sub_heading1")
					.setText(subHeading);
					document.getRootElement().getChild("data").getChild("main").getChild("pdf_section_sub_heading2")
					.setText("");
					document.getRootElement().getChild("data").getChild("main").getChild("pdf_section_sub_heading3")
					.setText("");
				}
				
			}
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
			getQuestionElement(userid, main, translationConstants,language);
			LOGGER.info(
					"root element" + document.getRootElement().getChild("data").getChild("main").getChildText("score"));
			XMLOutputter xmOut = new XMLOutputter(); 
			LOGGER.info("----" + xmOut.outputString(document));
			Doc2Pdf.start(document, xslFileName, pdfFileName);
			LOGGER.info("imagePath..." + imagePath);
			LOGGER.info("uploadImagePath..." + uploadImagePath);
			LOGGER.info("uploadedImageName..." + imageName);
			LOGGER.info("score..." + score);
			LOGGER.info("img..." + img);
			LOGGER.info("user..." + user);
			LOGGER.info("end");
		} catch (Exception exp) {
			LOGGER.error("cannot generate pdf :", exp);
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

		LOGGER.info("request path is : " + req.getServletPath());
		LOGGER.info("all end points in this controller : \n");
		// for(HandlerMethod endPoint :
		// requestMappingHandlerMapping.getHandlerMethods().values()) {
		// LOGGER.info(endPoint. + "\n");
		// }
		List<String> langs = getLangs();
		String requestedLanguage = req.getServletPath().substring(1);
		boolean noLanguage = true;
		for (String language : langs) {
			if (requestedLanguage.equalsIgnoreCase(language) || requestedLanguage.equalsIgnoreCase("english")) {
				noLanguage = false;
				session.setAttribute("language", requestedLanguage);
				req.setAttribute("language", requestedLanguage);
			}
		}
		if(noLanguage) {
			session.setAttribute("language", "english");
			req.setAttribute("language", "english");
		}
		loadData();
		if(noLanguage) {
			return "redirect:/";
		}
		return "index";
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
	// LOGGER.info("requested for " + req.getRequestURL());
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
		LOGGER.info("getQuestions method called with lang: " + lang);
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
			LOGGER.error("error getting question :", exp);
			exp.printStackTrace();
		} finally {
			close();
		}
		return hs;
	}

	public Hashtable<String, String> getAnswers(String userid) {
		LOGGER.info("getAnswers for userid : " + userid);
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
			LOGGER.error("cannot get answers :", exp);
			exp.printStackTrace();
		} finally {
			close();
		}
		return hs;
	}
	
	public Hashtable<String, List<String>> getResponseAverage(String lang) {
		if (nullCheck(lang).length() == 0 || lang.equals("en")) {
			lang = "english";
		}
		LOGGER.info("getResponseAverage for lang : " + lang);
		Hashtable<String, List<String>> hs = new Hashtable<String, List<String>>();
		ArrayList<String> avgResponse;
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement("select qid, avg(qresponse='yes') as yesAvg,avg(qresponse='no') as noAvg,avg(qresponse='notsure') as notSureAvg " + 
										"from sas.userresponse, sas.questions " +
										"where sas.questions.id = sas.userresponse.qid and sas.questions.lang=? "+
										"group by qid;");
			stmt.setString(1, lang);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				avgResponse = new ArrayList<String>();
				avgResponse.add(rs.getString("yesAvg"));
				avgResponse.add(rs.getString("noAvg"));
				avgResponse.add(rs.getString("notSureAvg"));
				hs.put(rs.getString("qid"),avgResponse);
			}
		} catch (Exception exp) {
			LOGGER.error("cannot get response average :", exp);
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
		LOGGER.info("loadData called ...");
		String lang = (String) session.getAttribute("language");
		if (lang == null)
			lang = req.getParameter("language");
		
		req.setAttribute("labels", getData("labels", "labelkey", "labelvalue", lang));
		req.setAttribute("language", lang);
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
		LOGGER.info("getData called with lang:" + lang);
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
			LOGGER.error("cannot get data from table " + table + " :", exp);
			exp.printStackTrace();
		} finally {
			close();
		}
		return hs;
	}

	private void saveUser() {
		LOGGER.info("save user called");
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement(
					"insert into registrationinfo (f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, lang) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			// LOGGER.info("email
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
			stmt.setString(17, nullCheck(req.getParameter("f17")));
			stmt.setString(18, nullCheck(req.getParameter("f18")));
			stmt.setString(19, "english");
			stmt.executeUpdate();
		} catch (Exception exp) {
			LOGGER.error("cannot able to save user :", exp);
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
			LOGGER.error("cannot able to close db connection :", exp);
			exp.printStackTrace();
		}
	}

	private void saveUserResponse() {
		LOGGER.info("save user response called");
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
					if(tempst.countTokens() == 2) {
						stmt.setString(1, userid);
						stmt.setString(2, tempst.nextToken());
						stmt.setString(3, tempst.nextToken());
						stmt.executeUpdate();
					} else {
						LOGGER.error("Improper user response token : " + temp);
					}
				}
			} catch (Exception exp) {
				LOGGER.error("cannot able to save user response :", exp);
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
			LOGGER.error("cannot able to get user id for mailid " + key +" :", exp);
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
			LOGGER.error("cannot able to get user information :", exp);
			exp.printStackTrace();
		} finally {
			close();
		}
		return list;
	}
	private String getNextAutoIncrementId(String tableName) {
		String nextAutoIncrementId = null;
		try {
			String sql = "SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_NAME = '" + tableName + "'";
			con = dataSource.getConnection();
			stmt = con.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				nextAutoIncrementId = rs.getString(1);
			}
		} catch (Exception exp) {
			LOGGER.error("cannot able to get next autoincrement value :", exp);
			exp.printStackTrace();
		} finally {
			close();
		}
		return nextAutoIncrementId;
	}
	private void saveLangData(Map<String, MultipartFile> fileMap, MultipartHttpServletRequest request) {
		try {
			String lang = req.getParameter("language");
			if (lang == null) {
				lang = (String) session.getAttribute("language");
			}
			if (nullCheck(lang).length() == 0 || lang.equals("en") || lang.equals("master")) {
				lang = "english";
			}
			String editedquestions = req.getParameter("editedquestions");
			for(String key: fileMap.keySet()) {
				//System.out.println("key : " + key);
				if(key.endsWith("-1")) { // create new images for new questions
					MultipartFile file = fileMap.get(key);
					if(file!=null) {
						//String newId = getNextAutoIncrementId("questions");
						//String fileName = key.substring(key.indexOf("_") + 1, key.lastIndexOf("_")) + "-" + lang + "-" + newId;
						uploadFiles(file, request, false,null);
					}
				} else { // // create new images for edited questions
					String id = key.substring(key.lastIndexOf("_") + 1);
					if(editedquestions != null) {
						String[] editedQuestionIds = editedquestions.split("[,]");
						for(String edidtedQuestionId : editedQuestionIds) {
							if(id.equals(edidtedQuestionId)) {
								MultipartFile file = fileMap.get(key);
								if(file!=null) {
									//String fileName = key.substring(key.indexOf("_") + 1, key.lastIndexOf("_")) + "-" + lang + "-" + id;
									uploadFiles(file, request, true, null);
								}
							}
						}
					}
				}
			}
			
			if (lang.equals("english")) {
				updateEnglishData();
			} else {
				boolean update = getData(lang);
				if (update) {
					LOGGER.info("updating data for lang:" + lang);
					updateData();
				} else {
					LOGGER.info("inserting data for lang:" + lang);
					insertData();
				}
			}
		} catch (Exception exp) {
			LOGGER.error("cannot able to save language data :", exp);
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	@SuppressWarnings("deprecation")
	private void uploadFiles(MultipartFile file, MultipartHttpServletRequest request, boolean isEdited, String fileName) {				
			
			try {
				String UPLOAD_DIRECTORY = "support" + File.separator + "img" + File.separator + "resourceFiles";
		    	String realPath = req.getRealPath("/");
		    	String uploadPath = realPath + File.separator + UPLOAD_DIRECTORY;
					if (file.isEmpty()) {
						System.out.println("=======file.isEmpty ======== ");
		        }else{
		        		System.out.println("======= UPLOAD_DIRECTORY ======"+uploadPath);
		        		System.out.println("=======file.getOriginalFilename() ======== "+file.getOriginalFilename());
		            byte[] bytes = file.getBytes();
		            //Path path = Paths.get(uploadPath + File.separator + fileName+file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".")).toLowerCase());
		            Path path = Paths.get(uploadPath + File.separator + file.getOriginalFilename());
		            if(isEdited) {
		            	//Files.copy(path, path, StandardCopyOption.REPLACE_EXISTING);
		            	Files.write(path, bytes);
		            } else {
		            	Files.write(path, bytes);
		            }
		        }


					// checks if the request actually contains upload file
					if (!ServletFileUpload.isMultipartContent(request)) {
						// if not, we stop here
						PrintWriter writer = res.getWriter();
						writer.println("Error: Form must has enctype=multipart/form-data.");
						writer.flush();
						return;
					}
			} catch(Exception ex) {
				LOGGER.error("Error at file upload", ex);
				ex.printStackTrace();
			}
			/*String UPLOAD_DIRECTORY = "support\\img\\resourceFiles\\123\\";
			// configures upload settings
			DiskFileItemFactory   factory = new DiskFileItemFactory();
			factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
			ServletFileUpload upload = new ServletFileUpload(factory);
			boolean isMultipart = ServletFileUpload.isMultipartContent(req);
			//MultipartHttpServletRequest multipartRequest = new DefaultMultipartHttpServletRequest(req);
			// parses the request's content to extract file data
			@SuppressWarnings("unchecked")
			List<FileItem> formItems = (List<FileItem>) upload.parseRequest(req);
			LOGGER.info("formItems.....:" + formItems);
			LOGGER.info("formItems.....:" + formItems.size());
			String realPath = req.getRealPath("/");
			String uploadPath = realPath + File.separator + UPLOAD_DIRECTORY;
			File uploadDir = new File(uploadPath);
			*/
			//File up = new File("C:\\temp");
			
			
			//MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) req;
			/*Iterator fileNames = multipartRequest.getFileNames();
			if (fileNames.hasNext()) {
			    String fileName = (String) fileNames.next();
			    System.out.println("***** fileName = " + fileName);
			    MultipartFile file = multipartRequest.getFile(fileName);
			    System.out.println("***** file size : " + file.getSize());
			}
			
			if (!uploadDir.exists()) {
				uploadDir.mkdir();
			}
			if (formItems != null && formItems.size() > 0) {
				// iterates over form's fields
				for (FileItem item : formItems) {
					// processe s only fields that are not form fields
					if (!item.isFormField() && !item.getName().equals("")) {
						String fileName = new File(item.getName()).getName();
						String filePath = uploadPath + File.separator + fileName;
						File storeFile = new File(filePath);
						// saves the file on disk
						item.write(storeFile);
						LOGGER.info("filename uploaded...:" + fileName);
					}
				}
			}

		} catch (Exception ex) {
			LOGGER.error("There was an error in uploading image: " + ex.getMessage());
		}*/

	}

	private void updateEnglishData() {
		String labels = req.getParameter("labels");
		String questions = req.getParameter("questions");
		String userformsfields = req.getParameter("userformsfields");
		
		String lang = req.getParameter("language");
		if (lang == null) {
			session.getAttribute("language");
		}
		if (nullCheck(lang).length() == 0 || lang.equals("en") || lang.equals("master")) {
			lang = "english";
		}
		String deletedquestions = req.getParameter("deletedquestions");
		String editedquestions = req.getParameter("editedquestions");
		LOGGER.info("lang:" + lang);
		LOGGER.info("labels:" + labels);
		LOGGER.info("questions:" + questions);
		LOGGER.info("deletedquestions:" + deletedquestions);
		LOGGER.info("editedquestions:" + editedquestions);
		LOGGER.info("userformsfields:" + userformsfields);
		String newId = getNextAutoIncrementId("questions");
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
				if(st.countTokens()==2) {
					temp1 = st.nextToken();
					temp2 = st.nextToken();
					stmt.setString(1, temp2);
					stmt.setString(2, temp1);
					stmt.setString(3, lang);
					stmt.executeUpdate();
				} else {
					LOGGER.error("No value found for Lable String: " + labelsToken);
				}
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
				if(st.countTokens()==7){
					temp1 = st.nextToken(); // id
					temp2 = st.nextToken(); // qtype
					temp3 = st.nextToken(); // qtext
					temp6 = st.nextToken(); // qsubtype
					temp4 = st.nextToken(); // qdesc
					temp5 = st.nextToken(); // imagename
					//String imagetype = temp5.substring(temp5.lastIndexOf("."));
					temp7 = st.nextToken(); // order
					if (!nullCheck(temp1).equals("-1")) {
						stmt.setString(1, temp3);
						stmt.setString(2, temp4);
						//stmt.setString(3, temp2 + "-" + lang + "-"+ temp1 + imagetype);
						//System.out.println(temp2 + "-" + lang + "-"+ temp1 + imagetype);
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
						//pstmt.setString(4, temp5);
						//pstmt.setString(4, temp2 + "-" + lang + "-"+ newId + imagetype);
						//System.out.println(temp2 + "-" + lang + "-"+ newId + imagetype);
						pstmt.setString(4, temp5);
						pstmt.setString(5, "english");
						pstmt.setString(6, null);
						pstmt.setString(7, temp6);
						pstmt.setString(8, temp7);
						pstmt.executeUpdate();
						eqid = getEnglishQId(temp2, temp3, temp4, temp5);
						for (int i = 0; i < langs.size(); i++) {
							LOGGER.info("inserting question for the language: " + langs.get(i));
							pstmt.setString(5, langs.get(i));
							pstmt.setString(6, eqid);
							pstmt.executeUpdate();
						}
					}
				} else {
					LOGGER.error("Improper question for the token : " + qToken);
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
			LOGGER.error("cannot able to update english data: " , exp);
			exp.printStackTrace();
		} finally {
			close();
			try {
				if (pstmt != null)
					pstmt.close();
				if (ustmt != null)
					ustmt.close();
			} catch (Exception exp) {
				LOGGER.error("cannot able to close db statement: " , exp);
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
			LOGGER.error("cannot able to get questions in getEnglishQId method : " , exp);
			exp.printStackTrace();
		} finally {
			try {
				if (con1 != null)
					con1.close();
				if (pstmt1 != null)
					pstmt1.close();
			} catch (Exception exp) {
				LOGGER.error("cannot able to close db connection : " , exp);
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
			LOGGER.info("sql stmt for lang....:" + sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				temp = rs.getString(1);
				if (temp != null && !temp.equalsIgnoreCase("english")) {
					list.add(rs.getString(1));
				}
			}
		} catch (Exception exp) {
			LOGGER.error("cannot able to get languages in getLangs methods : " , exp);
			exp.printStackTrace();
		} finally {
			close();
		}
		return list;
	}

	private void updateData() {
		String labels = req.getParameter("labels");
		String questions = req.getParameter("questions");
		String lang = req.getParameter("language");
		if (lang == null) {
			session.getAttribute("language");
		}
		if (nullCheck(lang).length() == 0 || lang.equals("en") || lang.equals("master")) {
			lang = "english";
		}
		LOGGER.info("lang:" + lang);
		LOGGER.info("labels:" + labels);
		LOGGER.info("questions:" + questions);
		String userformsfields = req.getParameter("userformsfields");
		LOGGER.info("userformsfields:" + userformsfields);
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
				if(st.countTokens()==2){
					temp1 = st.nextToken();
					temp2 = st.nextToken();
					stmt.setString(1, temp2);
					stmt.setString(2, temp1);
					stmt.setString(3, lang);
					stmt.executeUpdate();
				} else {
					LOGGER.error("Improper label for the token : " + labelsToken);
				}
			}

			String questionInsert = "update questions set qtext = ?, qdesc = ?, imagename = ?, qsubtype = ?, qorder = ? where id = ?";
			stmt = con.prepareStatement(questionInsert);
			StringTokenizer qToken = new StringTokenizer(questions, "|");
			while (qToken.hasMoreElements()) {
				st = new StringTokenizer(qToken.nextToken(), ":");
				LOGGER.info("st token length....:" + st.countTokens());
				// id:section:question:desc:imageName
				// id:section:question:subsection:desc:imageName:order
				if(st.countTokens()==7){
					temp1 = st.nextToken(); // id
					temp2 = st.nextToken(); // qtype
					temp3 = st.nextToken(); // qtext
					temp4 = st.nextToken(); // qsubtype
					temp5 = st.nextToken(); // qdesc
					temp6 = st.nextToken(); // imagename
					temp7 = st.nextToken(); // qorder
					//String imagetype = temp6.substring(temp6.lastIndexOf("."));
					//System.out.println(temp2 + "-" + lang + "-"+ temp1 + imagetype);
					stmt.setString(1, temp3);
					stmt.setString(2, temp5);
					stmt.setString(3, temp6);
					//stmt.setString(3,temp2 + "-" + lang + "-"+ temp1 + imagetype);
					stmt.setString(4, temp4);
					stmt.setString(5, temp7);
					stmt.setString(6, temp1);
					stmt.executeUpdate();
				} else {
					LOGGER.error("Improper question for the token : " + qToken);
				}
			}
		} catch (Exception exp) {
			LOGGER.error("cannot able to update data from method updateData : " , exp);
			exp.printStackTrace();
		}
	}

	private void insertData() {
		String temp = null;
		String labels = req.getParameter("labels");
		String questions = req.getParameter("questions");
		String lang = req.getParameter("language");
		if (lang == null) {
			lang = (String) session.getAttribute("language");
		}
		LOGGER.info("lang:" + lang);
		LOGGER.info("labels:" + labels);
		LOGGER.info("questions:" + questions);
		String userformsfields = req.getParameter("userformsfields");
		LOGGER.info("userformsfields:" + userformsfields);
		String newId = getNextAutoIncrementId("questions");
		insertFormFields(userformsfields, lang);
		try {
			con = dataSource.getConnection();
			StringTokenizer st = null;
			String labelInsert = "insert into labels (lang, labelkey, labelvalue) values (?,?,?)";
			stmt = con.prepareStatement(labelInsert);
			StringTokenizer labelsToken = new StringTokenizer(labels, "|");
			while (labelsToken.hasMoreElements()) {
				st = new StringTokenizer(labelsToken.nextToken(), ":");
				if(st.countTokens()==2) {
					stmt.setString(1, lang);
					stmt.setString(2, st.nextToken());
					stmt.setString(3, st.nextToken());
					stmt.executeUpdate();
				} else {
					LOGGER.error("Improper label for the token : " + labelsToken);
				}
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
				if(st.countTokens()==7) {
					temp = st.nextToken(); // id avoid
					String qtype = st.nextToken();
					stmt.setString(1, qtype); // qtype
					stmt.setString(2, st.nextToken()); // qtext
					stmt.setString(7, st.nextToken()); // subsection
					stmt.setString(3, st.nextToken()); // qdesc
					stmt.setString(4, st.nextToken()); // imagename 
					//String imageName = st.nextToken();
					//String imagetype = imageName.substring(imageName.lastIndexOf("."));
					//stmt.setString(4, qtype + "-" + lang + "-"+ newId + imagetype);
					//System.out.println(qtype + "-" + lang + "-"+ newId + imagetype);
					stmt.setString(5, lang);
					stmt.setString(6, temp); // parentquestion
					stmt.setString(8, st.nextToken());
	
					stmt.executeUpdate();
				} else {
					LOGGER.error("Improper question for the token : " + qToken);
				}
			}
		} catch (Exception exp) {
			LOGGER.error("cannot able to insert data from method insertData : " , exp);
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
			LOGGER.error("cannot able to get labels from method getData : " , exp);
			exp.printStackTrace();
		} finally {
			close();
		}
		return value;
	}

	public Hashtable<String, String> getFormFields(String lang) {
		Hashtable<String, String> hs = new Hashtable<String, String>();
		LOGGER.info("getFormFields method called with lang: " + lang);
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
			LOGGER.error("cannot able to get labels from method getData : " , exp);
			exp.printStackTrace();
		} finally {
			close();
		}

		return hs;
	}

	private void insertFormFields(String data, String lang) {
		LOGGER.info("data in insertFormFields....:" + data);

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
			LOGGER.error("cannot able to get registration fields from method registrationfields : " , exp);
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	private void updateFormFields(String data) {
		LOGGER.info("data in updateformfields....:" + data);

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
			LOGGER.error("cannot able to update registration fields from method updateFormFields : " , exp);
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	private void loadUserSelectionData(String lang) {
		LOGGER.info("loadUserSelectionData called with lang:" + lang);
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
			LOGGER.error("cannot able to get registration fields from method loadUserSelectionData : " , exp);
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
			LOGGER.error("cannot able to get options data from method getOptionsData : " , exp);
			exp.printStackTrace();
		} finally {
			close();
		}
	}

	private void getQuestionElement(String userid, Element main, Hashtable<String, String> translationConstants, String language) {
		LinkedHashMap<String, LinkedHashMap<String, List<Question>>> hs = new LinkedHashMap<String, LinkedHashMap<String, List<Question>>>();
		LinkedHashMap<String, List<Question>> hsSubType;// = new LinkedHashMap<String, List<Question>>();
		if (language == null || language.equals("null")|| nullCheck(language).length() == 0 || language.equals("en")) {
			language = "english";
		}
		try {
			//String sql = "select * from questions where id in (select qid from userresponse where qresponse != ? and userid=? order by qid)";
			String sql = "select * from questions where lang = ? order by id, qsubtype";
			
			con = dataSource.getConnection();
			stmt = con.prepareStatement(sql);
			stmt.setString(1, language);
			//stmt.setString(1, "yes");
			//stmt.setString(2, userid);
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
				//list = hs.get(q.getType());
				hsSubType = hs.get(q.getType());
				if (hsSubType == null) {
					hsSubType = new LinkedHashMap<String, List<Question>>();
				}
				list = hsSubType.get(q.getSubtype());
				if (list == null) {
					list = new ArrayList<Question>();
				}
				list.add(q);
				hsSubType.put(q.getSubtype(), list);
				hs.put(q.getType(), hsSubType);
			}
		} catch (Exception exp) {
			LOGGER.error("cannot able to get questions from method getQuestionElement : " , exp);
			exp.printStackTrace();
		} finally {
			close();
		}
		LinkedHashMap<String, String> responseMap = new LinkedHashMap<String, String>();
		try {
			String sql = "SELECT qid, qresponse FROM userresponse where userid = ? order by id";
			con = dataSource.getConnection();
			stmt = con.prepareStatement(sql);
			stmt.setString(1, userid);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				responseMap.put(rs.getString("qid"),rs.getString("qresponse"));
			}
		} catch (Exception exp) {
			LOGGER.error("cannot able to get questions from method getQuestionElement : " , exp);
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
				if(key.equals("plan"))
					title.setText(translationConstants.get(SASConstants.PLAN_REPORT_DESC));
				else if(key.equals("do"))
					title.setText(translationConstants.get(SASConstants.DO_REPORT_DESC));
				else if(key.equals("check"))
					title.setText(translationConstants.get(SASConstants.CHECK_REPORT_DESC));
				attribute = new Attribute("id", index + "");
				title.setAttribute(attribute);
				LOGGER.info("key...." + key);
				planElement.addContent(title);
				
				LinkedHashMap<String, List<Question>> hsSubType1 = hs.get(key);
				Element subSectionElement = null;
				Iterator<String> subSectionKeys = hsSubType1.keySet().iterator();
				while (subSectionKeys.hasNext()) {
					String subSectionName = subSectionKeys.next();
					subSectionElement = new Element("subsection");
					Element subSectionTitle = new Element("title");
					subSectionTitle.setText(subSectionName);
					subSectionElement.addContent(subSectionTitle);
					list = hsSubType1.get(subSectionName);
					for (int i = 0; i < list.size(); i++) {
						q = list.get(i);
						qElem = new Element("question");
						temp = new Element("title");
						temp.setText("Q" + q.getQorder());
						qElem.addContent(temp);
						temp = new Element("response");
						if(responseMap.containsKey(q.getId()) && responseMap.get(q.getId()).equals("yes")) {
							temp.setText("true");
						} else {
							temp.setText("false");
						} 
						qElem.addContent(temp);
						temp = new Element("value");
						temp.setText(q.getText());
						qElem.addContent(temp);
						temp = new Element("answer");
						temp.setText(q.getDesc());
						qElem.addContent(temp);
						subSectionElement.addContent(qElem);
					}
					planElement.addContent(subSectionElement);
				}
				
				main.addContent(planElement);
				XMLOutputter xmOut = new XMLOutputter(); 
				LOGGER.info("----" + xmOut.outputString(main.getDocument()));
				index++;
			}
		} catch (Exception exp) {
			LOGGER.error("cannot able to create plan element for pdf method getQuestionElement : " , exp);
			exp.printStackTrace();
		}
	}

	public void postEloqua(String userId, String pdfFilePath, String language) throws IOException {

		try {

			Resource resource = new ClassPathResource("/application.properties");
			Properties properties = PropertiesLoaderUtils.loadProperties(resource);
			String token = properties.getProperty(SASConstants.COMPANY_NAME) + "\\"
					+ properties.getProperty(SASConstants.ELOQUA_USER) + ":"
					+ properties.getProperty(SASConstants.ELOQUA_PWD);
			byte[] encodedBytes = Base64.encodeBase64(token.getBytes());
			String encodedToken = "Basic " + new String(encodedBytes);
			//String eloquaUrl = properties.getProperty(SASConstants.ELOQUA_URL_CUSTOM_OBJECT);
			String eloquaUrl = properties.getProperty(SASConstants.ELOQUA_URL_FORM);
			String jsonStr = getData4Eloqua(properties, userId, pdfFilePath, language);
			LOGGER.info("eloqua json = " + jsonStr);
			//LOGGER.info("eloqua url = https://secure.p06.eloqua.com/api/REST/2.0/data/customObject/34/instance");
			LOGGER.info("eloqua url = " + SASConstants.ELOQUA_URL_FORM);
			LOGGER.info("eloqua json = " + jsonStr);
			com.mashape.unirest.http.HttpResponse<String> response = Unirest.post(eloquaUrl)
					.header("authorization", encodedToken).header("content-type", "application/json")
					.header("cache-control", "no-cache").header("postman-token", "6c51d19d-2327-fc92-8218-c8dd22ac35ee")
					.body(jsonStr).asString();
			LOGGER.info(response.getBody());
			LOGGER.info(response.getBody());
		} catch (UnirestException e) {
			LOGGER.error("can able to send data to eloqua:", e);
			e.printStackTrace();
		}
	}

	public String getData4Eloqua(Properties properties, String userId, String pdfFilePath, String language) {
		String jsonStr = null;
		// String userId = (String) req.getAttribute("userid");
		LOGGER.info(pdfFilePath);
		Map<String, String> map = new HashMap<String, String>();
		try {
			con = dataSource.getConnection();
			stmt = con.prepareStatement(
					"select info.f18,info.f17,info.f6, info.f5, info.f7, info.f4, info.f1, info.f2, info.f3, info.id, info.lang, response.qid, response.qresponse from registrationinfo info, userresponse response where info.id=response.userid and info.id=? ");
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
					LOGGER.info("site stored ::" + language);
					LOGGER.info("site stored ::" , rs.getString("lang"));
					if (nullCheck(language).length() == 0) {
						language = "english";
					}
					if(language == null || language.equals("english") || language.equals("null"))
						language = "master";
					LOGGER.info("LANGUAGE ::" + language);
					map.put(properties.getProperty(SASConstants.LANGUAGE), language);
					map.put(properties.getProperty(SASConstants.TNC_ACCEPTANCE), rs.getString("f18"));
					map.put(properties.getProperty(SASConstants.COMMS_ACCEPTANCE), rs.getString("f17"));
					map.put(properties.getProperty(SASConstants.BUSSINESS_INDUSTRY), rs.getString("f6"));
					map.put(properties.getProperty(SASConstants.COMPANY), rs.getString("f5"));
					map.put(properties.getProperty(SASConstants.COUNTRY), rs.getString("f7"));
					map.put(properties.getProperty(SASConstants.EMAIL), rs.getString("f4"));
					map.put(properties.getProperty(SASConstants.FIRST_NAME), rs.getString("f1"));
					map.put(properties.getProperty(SASConstants.LAST_NAME), rs.getString("f2"));
					map.put(properties.getProperty(SASConstants.TITLE), rs.getString("f3"));
					map.put(properties.getProperty(SASConstants.USER_ID), "XY"+ rs.getString("id"));
					map.put(properties.getProperty(SASConstants.QUESTION_ID), rs.getString("qid"));
					map.put(properties.getProperty(SASConstants.QUESTION_RESPONSE), rs.getString("qresponse"));
					map.put(properties.getProperty(SASConstants.REPORT_PDF_NAME), pdfFilePath);
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
			map = setEloquaExtraVaues(map,userId,properties);
			//jsonStr = generateJson(properties, map);
			jsonStr = generateJsonNew(properties, map);

		} catch (Exception exp) {
			LOGGER.error("cannot able to get data for eloqua from  method getData4Eloqua : " , exp);
			exp.printStackTrace();
		} finally {
			close();
		}
		return jsonStr;
	}

	public Map<String, String> setEloquaExtraVaues(Map<String, String> mapdataMap, String userId, final Properties properties) throws SQLException {
		//String sql = "select questions.qsubtype, count(userresponse.qresponse) totalCount, COUNT(CASE WHEN userresponse.qresponse='yes' THEN 1 END) AS totalYesCount from questions, userresponse where questions.id = userresponse.qid and userresponse.userid=? group by questions.qsubtype;";
		con = dataSource.getConnection();
		stmt = con.prepareStatement(
				"select questions.qsubtype, count(userresponse.qresponse) totalCount, COUNT(CASE WHEN userresponse.qresponse='yes' THEN 1 END) AS totalYesCount from questions, userresponse where questions.id = userresponse.qid and userresponse.userid=? group by questions.qsubtype;");
		stmt.setString(1, userId);
		ResultSet rs = stmt.executeQuery();
		Map<String, String> map = new HashMap<String, String>();
		while (rs.next()) {
			String qtype = rs.getString("qsubtype");
			if(qtype.equals(SASConstants.QTYPE_ASSESS_RISK)) {
				map.put(properties.getProperty(SASConstants.REPORT_ASSESS_RISKS), getPercentageValue(rs.getString("totalYesCount"),rs.getString("totalCount")));
			} else if(qtype.equals(SASConstants.QTYPE_PLAN)) {
				map.put(properties.getProperty(SASConstants.REPORT_PLAN), getPercentageValue(rs.getString("totalYesCount"),rs.getString("totalCount")));
			} else if(qtype.equals(SASConstants.QTYPE_POLICIES)) {
				map.put(properties.getProperty(SASConstants.REPORT_POLICIES_PROCESSES), getPercentageValue(rs.getString("totalYesCount"),rs.getString("totalCount")));
			} else if(qtype.equals(SASConstants.QTYPE_MOBILITY)) {
				map.put(properties.getProperty(SASConstants.REPORT_MANAGE_MOBILITY), getPercentageValue(rs.getString("totalYesCount"),rs.getString("totalCount")));
			} else if(qtype.equals(SASConstants.QTYPE_COMMUNICATE)) {
				map.put(properties.getProperty(SASConstants.REPORT_COMMUNICATE_EDUCATE_TRAIN), getPercentageValue(rs.getString("totalYesCount"),rs.getString("totalCount")));
			} else if(qtype.equals(SASConstants.QTYPE_LOCATE)) {
				map.put(properties.getProperty(SASConstants.REPORT_LOCATE_MONITOR_INFORM), getPercentageValue(rs.getString("totalYesCount"),rs.getString("totalCount")));
			} else if(qtype.equals(SASConstants.QTYPE_ADVICE)) {
				map.put(properties.getProperty(SASConstants.REPORT_ADVICE_ASSIST_EVACUATE), getPercentageValue(rs.getString("totalYesCount"),rs.getString("totalCount")));
			} else if(qtype.equals(SASConstants.QTYPE_CONTROL)) {
				map.put(properties.getProperty(SASConstants.REPORT_CONTROL_REVIEW), getPercentageValue(rs.getString("totalYesCount"),rs.getString("totalCount")));
			}
			
		}
	  Iterator<String> iterator = map.keySet().iterator();
	  while(iterator.hasNext()) {
		  String key = iterator.next();
		  mapdataMap.put(key, map.get(key));
	  }
		return mapdataMap;
	}
	
	private String getPercentageValue(String toatalYesCount, String toatlQuestionCount) {
		DecimalFormat decimalFormat = new DecimalFormat("#.##");
		double percentage = Double.parseDouble(toatalYesCount)/Double.parseDouble(toatlQuestionCount);
		String percentageStr= decimalFormat.format(percentage);
		return percentageStr;
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

		LOGGER.info(JSONObject.quote(dataset.toString()));

		return dataset.toString();
	}
	
	public String generateJsonNew(Properties properties, Map<String, String> hs) {
		JSONObject dataset = new JSONObject();
		JSONArray fieldset = new JSONArray();
		for (String key : hs.keySet()) {
			JSONObject field = new JSONObject();
			field.put("type", "FieldValue");
			field.put("id", key);
			field.put("value", hs.get(key));
			field.put("iref", properties.getProperty(getProperty(properties, key) + ".ref"));
			fieldset.put(field);
		}
		dataset.put("fieldValues", fieldset);

		LOGGER.info(JSONObject.quote(dataset.toString()));

		return dataset.toString();
	}

	private String getProperty(Properties properties, String value) {
		String key="";
		Enumeration<Object> keys = properties.keys();
		while(keys.hasMoreElements()) {
			key = keys.nextElement().toString();
			if(properties.getProperty(key).equals(value)) {
				break;
			}
		}
		return key;
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

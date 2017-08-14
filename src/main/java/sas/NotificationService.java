package sas;

import java.io.File;
import java.util.StringTokenizer;

import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Service;

@Service
@EnableAsync
public class NotificationService {
	private static final Logger LOGGER = LoggerFactory.getLogger(NotificationService.class);
	private JavaMailSender sender;

	@Autowired
	public NotificationService(JavaMailSender javaMailSender) {
		this.sender = javaMailSender;
	}

	@Async
	public void sendNotificaitoin(String pdfAttachementFileName, String scoreinfo) {
		try {
			Thread.sleep(10000);

			System.out.println("Sending email...");

			MimeMessage message = sender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true);
			StringTokenizer st = new StringTokenizer(scoreinfo, "|");
			String score = st.nextToken();
			String img = st.nextToken();
			String user = st.nextToken();
			String email = st.nextToken();
			String companyName = st.nextToken();
			String imageName = st.nextToken();
			System.out.println("email =" + email);
			if (st.hasMoreElements()) {
				user = user + " " + st.nextToken();
			}
			String subject = "Travel Risk Management self-assessment: You scored " + score + "%";
			String mailMessage = "Hi! " + user + ",\n";
			mailMessage = "Please find your assessment report.\n ";
			mailMessage += "Regards,\n ";
			mailMessage += "Self Assessment team";
			String pdfName = "SelfAssessmentReport.pdf";
			File pdfFile = new File(pdfAttachementFileName);

			helper.setTo(email);
			helper.setText(mailMessage);
			helper.setSubject(subject);
			helper.addAttachment(pdfName, pdfFile);
			sender.send(message);
		} catch (Exception e) {
			LOGGER.error("can not able to send mail.", e);
			e.printStackTrace();
		}

		System.out.println("Email Sent!");
	}
}

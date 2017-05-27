package sas;

import org.jdom.Document;
import org.jdom.transform.JDOMSource;
import org.apache.fop.apps.Driver;
import org.apache.fop.messaging.MessageHandler;
import org.apache.log4j.Logger;


import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;

import java.io.File;
import java.io.OutputStream;

import javax.xml.parsers.SAXParser;
//import embedding.model.*;

import org.apache.log4j.Logger;

/**
 * This class do the conversion of an arbitrary object file to a
 * PDF using JAXP (XSLT) and FOP (XSL:FO).
 */
public class Doc2Pdf {

    /**
     * The Logger
     */
    static Logger logger = Logger.getLogger(Doc2Pdf.class.getName());

    /**
     * Convert document to PDF
     * @param doc
     * @param xslt
     * @param pdf
     * @throws Exception
     */
    public static void convertDocument2PDF(Document doc, File xslt, File pdf) throws Exception {
        logger.debug("convertDocument2PDF(Document doc, File xslt, File pdf)");

        //Construct driver
        Driver driver = new Driver();
        logger.debug("Before setting logger ");

        //Setup logger
        /*driver.setLogger(new Log4JLogger(logger));
        MessageHandler.setScreenLogger(new Log4JLogger(logger));*/
        logger.debug("before setup renderer ");

        //Setup Renderer (output format)
        driver.setRenderer(Driver.RENDER_PDF);
        logger.debug("before setting output :"+pdf);

        //Setup output
        OutputStream out = new java.io.FileOutputStream(pdf);
        logger.debug("after setting output");

        try {

            driver.setOutputStream(out);
            logger.debug("after driver output is set");
            
            System.setProperty ("javax.xml.transform.TransformerFactory", "org.apache.xalan.processor.TransformerFactoryImpl"); 

            //Setup XSLT
            TransformerFactory factory = TransformerFactory.newInstance();
            Transformer transformer = factory.newTransformer(new StreamSource(xslt));
            logger.debug("after xsl read");

            //Setup input for XSLT transformation
            Source src = new JDOMSource(doc);
            logger.debug("after source read ");

            Result res = new SAXResult(driver.getContentHandler());
            logger.debug("after result ");

            transformer.transform(src, res);
            logger.debug("after trasform");
        }
        catch (Exception e) {
        	logger.error("error in convertDocument2PDF::",e);
            e.printStackTrace();
            throw new Exception("Unable to convert document to PDF " , e);

        }
        finally {

            out.close();
        }
    }

    /**
     * Start converting document to PDF.
     * @param doc
     * @param xslFileName
     * @param pdfFileName
     * @throws Exception
     */
    public static void start(Document doc, String xslFileName, String pdfFileName) throws Exception {
        logger.info("start(Document, " + xslFileName + ", " + pdfFileName + ")");

        try {
        	logger.debug("xsl file path:"+xslFileName);
           //Setup input and output
            File xsltfile = new File(xslFileName);
            File pdffile = new File(pdfFileName);
            logger.debug("Transforming...");
            convertDocument2PDF(doc, xsltfile, pdffile);
        }
        catch (Exception e) {
            logger.error("Error in FOP transform: " + e.getMessage());
            throw new Exception("Unable to convert document to PDF " , e);
        }
    }
}

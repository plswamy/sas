package sas;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.io.InternalResourceResolver;
import org.apache.fop.fonts.EmbedFontInfo;
import org.apache.fop.fonts.EmbeddingMode;
import org.apache.fop.fonts.EncodingMode;
import org.apache.fop.fonts.Font;
import org.apache.fop.fonts.FontCollection;
import org.apache.fop.fonts.FontTriplet;
import org.apache.fop.fonts.FontUris;
import org.apache.fop.render.RendererConfig.RendererConfigParser;
import org.apache.fop.render.pdf.PDFRendererConfigurator;

public class CustomPDFRendererConfigurator extends PDFRendererConfigurator {

	public CustomPDFRendererConfigurator(FOUserAgent userAgent, RendererConfigParser rendererConfigParser) {
        super(userAgent, rendererConfigParser);
    }

    @Override
    protected FontCollection getCustomFontCollection(InternalResourceResolver resolver, String mimeType)
            throws FOPException {

        List<EmbedFontInfo> fontList = new ArrayList<EmbedFontInfo>();
        try {
            //FontUris fontUris = new FontUris(Thread.currentThread().getContextClassLoader().getResource("D:\\myprojects\\InternatinalSOS\\master\\assessmyrisk\\sas\\src\\main\\resources\\simhei.ttf").toURI(), null);
        	//FontUris fontUris = new FontUris(new File("D:\\myprojects\\InternatinalSOS\\master\\assessmyrisk\\sas\\src\\main\\resources\\simhei.ttf").toURI(), null);
        	FontUris fontUris = new FontUris(new File("src/main/resources/simhei.ttf").toURI(), null);
        	List<FontTriplet> triplets = new ArrayList<FontTriplet>();
            triplets.add(new FontTriplet("SimHei", Font.STYLE_NORMAL, Font.WEIGHT_NORMAL));
            EmbedFontInfo fontInfo = new EmbedFontInfo(fontUris, false, false, triplets, null, EncodingMode.AUTO, EmbeddingMode.AUTO, false, false);
            fontList.add(fontInfo);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return createCollectionFromFontList(resolver, fontList);
    }

}

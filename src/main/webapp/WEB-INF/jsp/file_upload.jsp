<%@ page import="java.io.File" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>

<%
    // location to store file uploaded
    String UPLOAD_DIRECTORY = "support\\img\\resourceFiles\\123\\";
   
     // checks if the request actually contains upload file
    if (!ServletFileUpload.isMultipartContent(request)) {
        // if not, we stop here
        PrintWriter writer = response.getWriter();
        writer.println("Error: Form must has enctype=multipart/form-data.");
        writer.flush();
        return;
    }
 
    // configures upload settings
    DiskFileItemFactory factory = new DiskFileItemFactory();
    factory.setRepository(new File(System.getProperty("java.io.tmpdir"))); 
    ServletFileUpload upload = new ServletFileUpload(factory);
    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        uploadDir.mkdir();
    }
    try {
        // parses the request's content to extract file data
        @SuppressWarnings("unchecked")
        List<FileItem> formItems = upload.parseRequest(request);

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
                }
            }
        }
    } catch (Exception ex) {
        System.out.println("There was an error: " + ex.getMessage());
    }        
      
%>
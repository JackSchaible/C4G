<%@ WebHandler Language="C#" Class="ImageUploader" %>

using System;
using System.Web;
using System.IO;

public class ImageUploader : IHttpHandler 
{
    
    public void ProcessRequest (HttpContext context) 
    {

        string folderPath = HttpContext.Current.Server.MapPath("tmp\\Images\\Offers\\");
        string fileName = HttpContext.Current.User.Identity.Name + "OfferLogo";

        string ext = "";

        switch (HttpContext.Current.Request.ContentType)
        {
            case "image/gif":
                ext = ".gif";
                break;
                
            case "image/jpeg":
                ext = ".jpg";
                break;
                
            case "image/png":
                ext = ".png";
                break;
                
            case "image/pjpeg":
                ext = ".jpg";
                break;
                
            case "image/svg+xml":
                ext = ".svg";
                break;
                
            default:
                ext = ".jpg";
                break;
        }
        
        string physPath = folderPath + @"\" + fileName + ext;

        
        using (FileStream fs = File.Create(physPath))
        {
            Byte[] buffer = new Byte[32 * 1024];
            int read = context.Request.GetBufferlessInputStream().Read(buffer, 0, buffer.Length);
            while (read > 0)
            {
                fs.Write(buffer, 0, read);
                read = context.Request.GetBufferlessInputStream().Read(buffer, 0, buffer.Length);
            }
        }
    }
 
    public bool IsReusable 
    {
        get 
        {
            return false;
        }
    }

}
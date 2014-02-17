using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CouponsForGiving.Data
{
    [DataObject]
    public static class SysDatamk
    {
        #region Merchant

        // Insert a new Merchant
        // Returns ID of new Merchant.
        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static int AddMerchant(string name, 
                                      string largelogo, 
                                      string smalllogo, 
                                      string address,
                                      int citycode,
                                      string postalcode, 
                                      string phonenumber, 
                                      string website,
                                      int statusid,
                                      string username,
                                      string email)
        {
            int? rval = (new C4GEntities()).Merchant_Insert(name, largelogo, smalllogo, address, citycode, postalcode, phonenumber, website, statusid, username, email).FirstOrDefault();
            return rval ?? -1;
        }

        // Update an existing Merchant
        [DataObjectMethod(DataObjectMethodType.Update, false)]
        public static void UpdateMerchant(int merchantid,
                                          string name,
                                          string largelogo,
                                          string smalllogo,
                                          string address,
                                          int citycode,
                                          string postalcode,
                                          string phonenumber,
                                          string website,
                                          int statusid)
        {
            (new C4GEntities()).Merchant_Update(merchantid, name, largelogo, smalllogo, address, citycode, postalcode, phonenumber, website, statusid);
        }

        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static Merchant Merchant_GetByUsername(string username)
        {
            return (new C4GEntities().Merchant_GetByUsername(username)).FirstOrDefault<Merchant>();
        }
        #endregion

        #region MerchantLocation

        // Insert a new Merchant Location
        // Returns ID of new Merchant Location.
        //[DataObjectMethod(DataObjectMethodType.Insert, false)]
        //public static int AddMerchantLocation(int merchantid,
        //                                      string address,
        //                                      int citycode,
        //                                      string phonenumber)
        //{
        //    int? rval = (new C4GEntities()).MerchantLocation_Insert(merchantid, address, citycode, phonenumber).FirstOrDefault();
        //    return rval ?? -1;
        //}

        // Update an existing Merchant Location
        //[DataObjectMethod(DataObjectMethodType.Update, false)]
        //public static void UpdateMerchantLocation(int merchantlocationid,
        //                                          int merchantid,
        //                                          string address,
        //                                          int citycode,
        //                                          string phonenumber)
        //{
        //    (new C4GEntities()).MerchantLocation_Update(merchantlocationid, merchantid, address, citycode, phonenumber);
        //}

        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static List<MerchantLocation_GetByMerchantID_Result> GetMerchantLocationsByMerchantID (int merchantid)
        {
            return (new C4GEntities().MerchantLocation_GetByMerchantID(merchantid)).ToList<MerchantLocation_GetByMerchantID_Result>();
        }

        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static List<MerchantLocation_GetActiveByDealID_Result> GetActiveMerchantLocationsByDealID(int dealid)
        {
            return (new C4GEntities().MerchantLocation_GetActiveByDealID(dealid)).ToList<MerchantLocation_GetActiveByDealID_Result>();
        }

        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static List<MerchantLocation_GetEligible_Result> GetEligibleDealLocations(int merchantid, int dealid)
        {
            return (new C4GEntities().MerchantLocation_GetEligible(merchantid, dealid)).ToList<MerchantLocation_GetEligible_Result>();
        }

        [DataObjectMethod(DataObjectMethodType.Delete, false)]
        public static void DeleteDealMerchantLocation(int dealid, int merchantlocationid)
        {
            (new C4GEntities()).DealMerchantLocation_Delete(dealid, merchantlocationid);
        }

        #endregion

        #region Deal / Related
        

        

        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static Deal_Get_Result GetDealByID(int dealid)
        {
            return (new C4GEntities().Deal_Get(dealid)).FirstOrDefault<Deal_Get_Result>();
        }

        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static int AddDealInstance(int dealid,
                                          DateTime startdate,
                                          DateTime enddate,
                                          DateTime redeemableafter,
                                          DateTime expirydate,
                                          int dealstatusid)
        {
            int? rval = (new C4GEntities()).DealInstance_Insert(dealid, startdate, enddate, redeemableafter, expirydate, dealstatusid).FirstOrDefault();
            return rval ?? -1;
        }

        [DataObjectMethod(DataObjectMethodType.Update, false)]
        public static void UpdateDealInstance(int dealinstanceid,
                                          int dealid,
                                          DateTime startdate,
                                          DateTime enddate,
                                          DateTime redeemableafter,
                                          DateTime? expirydate,
                                          int dealstatusid)
        {
            (new C4GEntities()).DealInstance_Update(dealinstanceid, dealid, startdate, enddate, redeemableafter, expirydate, dealstatusid);
        }

        //[DataObjectMethod(DataObjectMethodType.Select, false)]
        //public static DealInstance_Get_Result GetDealInstance(int dealinstanceid)
        //{
        //    return (new C4GEntities()).DealInstance_Get(dealinstanceid).FirstOrDefault<DealInstance_Get_Result>();
        //}

        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static void AddDealMerchantLocation(int dealid,
                                                  int merchantlocationid)
        {
            (new C4GEntities()).DealMerchantLocation_Insert(dealid, merchantlocationid);
        }

        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static int AddDealSEO(int dealid,
                                     string metakeywords,
                                     string metadescription)
        {
            int? rval = (new C4GEntities()).DealSEO_Insert(dealid, metakeywords, metadescription).FirstOrDefault();
            return rval ?? -1;
        }

        [DataObjectMethod(DataObjectMethodType.Update, false)]
        public static void UpdateDealSEO(int dealseoid,
                                     int dealid,
                                     string metakeywords,
                                     string metadescription)
        {
            (new C4GEntities()).DealSEO_Update(dealseoid, dealid, metakeywords, metadescription);
        }

        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static int AddPrice(int dealid,
                                   decimal retailvalue,
                                   decimal giftvalue,
                                   decimal merchantsplit,
                                   decimal nposplit,
                                   decimal oursplit)
        {
            int? rval = (new C4GEntities()).Price_Insert(dealid, retailvalue, giftvalue, merchantsplit, nposplit, oursplit).FirstOrDefault();
            return rval ?? -1;
        }

        [DataObjectMethod(DataObjectMethodType.Update, false)]
        public static void UpdatePrice(int priceid,
                                   int dealid,
                                   decimal retailvalue,
                                   decimal giftvalue,
                                   decimal merchantsplit,
                                   decimal nposplit,
                                   decimal oursplit)
        {
            (new C4GEntities()).Price_Update(priceid, dealid, retailvalue, giftvalue, merchantsplit, nposplit, oursplit);
        }

        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static int AddRedeemDetails(int dealid,
                                           string additionaldetails,
                                           string restrictions,
                                           string highlights,
                                           string redeemdetailsdescription)
        {
            int? rval = (new C4GEntities()).RedeemDetails_Insert(dealid, additionaldetails, restrictions, highlights, redeemdetailsdescription).FirstOrDefault();
            return rval ?? -1;
        }

        [DataObjectMethod(DataObjectMethodType.Update, false)]
        public static void UpdateRedeemDetails(int redeemdetailsid,
                                           int dealid,
                                           string additionaldetails,
                                           string restrictions,
                                           string highlights,
                                           string redeemdetailsdescription)
        {
            (new C4GEntities()).RedeemDetails_Update(redeemdetailsid, dealid, additionaldetails, restrictions, highlights, redeemdetailsdescription);
        }
        #endregion

        #region NPO

        // Insert a new NPO
        // Returns ID of new NPO.
        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static int AddNPO(string name,
                                 string npodescription,
                                 string address,
                                 int citycode,
                                 string postalcode,
                                 string website,
                                 string phonenumber,
                                 string email,
                                 int statusid,
                                 string logo,
                                 string url,
                                 bool useallmerchants)
        {
            int? rval = (new C4GEntities()).NPO_Insert(name, npodescription, address, citycode, postalcode, website, phonenumber, email, statusid, logo, url, useallmerchants).FirstOrDefault();
            return rval ?? -1;
        }

        // Update an existing NPO
        [DataObjectMethod(DataObjectMethodType.Update, false)]
        public static void UpdateNPO(int npoid,
                                     string name,
                                     string npodescription,
                                     string address,
                                     int cityID,
                                     string postalcode,
                                     string website,
                                     string phonenumber,
                                     string email,
                                     int statusid,
                                     string logo,
                                     string url,
                                     bool useallmerchants)
        {
            (new C4GEntities()).NPO_Update(npoid, name, npodescription, address, cityID, postalcode, website, phonenumber, email, statusid, logo, url, useallmerchants);
        }

        // Check if URL is unique
        // Returns 0 if URL already exists, 1 if the URL is available
        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static int IsURLUnique(string testurl)
        {
            int? rval = (new C4GEntities()).NPO_IsURLUnique(testurl).FirstOrDefault();
            return rval ?? 0;
        }

        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static NPO NPO_GetByUsername(string username)
        {
            return (new C4GEntities().NPO_GetByUsername(username)).FirstOrDefault<NPO>();
        }
        #endregion

        #region NPOcUser
        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static void NPOcUser_Insert(string username, int npoid)
        {
            (new C4GEntities()).NPOcUser_Insert(username, npoid);
        }
        #endregion

        #region Campaign
        // Insert a new Campaign
        // Returns ID of New Campaign.
        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static int AddCampaign(string name,
                                      int npoid,
                                      DateTime startdate,
                                      DateTime enddate,
                                      string campaigndescription,
                                      int fundraisinggoal,
                                      string campaignimage,
                                      bool showonhome,
                                      int displaypriority,
                                      string campaigngoal)
        {
            int? rval = (new C4GEntities()).Campaign_Insert(name, npoid, startdate, enddate, campaigndescription, fundraisinggoal, campaignimage, showonhome, displaypriority, campaigngoal).FirstOrDefault();
            return rval ?? -1;
        }

        // Update an existing Campaign
        [DataObjectMethod(DataObjectMethodType.Update, false)]
        public static void UpdateCampaign(int campaignid,
                                          string name,
                                          int npoid,
                                          DateTime startdate,
                                          DateTime enddate,
                                          string campaigndescription,
                                          int fundraisinggoal,
                                          string campaignimage,
                                          bool showonhome,
                                          int displaypriority,
                                          string campaigngoal)
        {
            (new C4GEntities()).Campaign_Update(campaignid, name, npoid, startdate, enddate, campaigndescription, fundraisinggoal, campaignimage, showonhome, displaypriority, campaigngoal);
        }

        [DataObjectMethod(DataObjectMethodType.Insert, false)]
        public static void AddCampaignDealInstance(int campaignid,
                                                  int dealinstanceid)
        {
            (new C4GEntities()).CampaignDealInstance_Insert(campaignid, dealinstanceid);
        }
        #endregion

        #region City

        // Lists all Cities with Division Codes
        // Returns a list of complex type.
        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static List<City_ListAllWithDivisionCode_Result> ListCitiesWithDivisionCode()
        {
            return (new C4GEntities()).City_ListAllWithDivisionCode().ToList<City_ListAllWithDivisionCode_Result>();
        }

        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static string GetFullLocationByCityCode(int citycode)
        {
            return (new C4GEntities()).City_GetFullLocationByCityCode(citycode).FirstOrDefault();
        }
        #endregion

        #region cStatus
        // List All Campaigns for a given NPOID
        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public static cStatus_GetByID_Result GetStatusByID(int statusid)
        {
            return (new C4GEntities()).cStatus_GetByID(statusid).FirstOrDefault();
        }
        #endregion
    }
}

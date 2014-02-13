using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace CouponsForGiving.Data
{
    [DataObject]
    public static class SysData
    {
        #region Partnerships
        public static void RemovePartnership(int MerchantID, int NPOID)
        {
            new C4GEntities().RemovePartnership(NPOID, MerchantID);
        }

        public static void AddPartnership(int MerchantID, int NPOID)
        {
            new C4GEntities().InsertPartnership(NPOID, MerchantID);
        }
        #endregion
        #region Accounts
        public static void ApproveAllPending()
        {
            new C4GEntities().ApproveAllPendingAccounts();
        }
        #endregion
        #region Campaign
        public static Campaign Campaign_GetByNPO(int NPOID)
        {
            return (new C4GEntities()).Campaign_GetByNPO(NPOID).FirstOrDefault<Campaign>();
        }

        public static Campaign Campaign_Get(int CampaignID)
        {
            return (new C4GEntities()).Campaign_Get(CampaignID).FirstOrDefault<Campaign>();
        }

        public static Campaign Campaign_GetByName(string name, string npourl)
        {
            return new C4GEntities().Campaign_GetByName(name, npourl).FirstOrDefault<Campaign>();
        }

        public static bool Campaign_IsNameUnique(string name, int npoid)
        {
            if (new C4GEntities().Campaign_IsNameUnique(name, npoid).First() == 1)
                return true;
            else
                return false;
        }
        #endregion
        #region City
        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<GetCities_Result> ListCities()
        {
            return (new C4GEntities()).GetCities().ToList<GetCities_Result>();
        }
        #endregion
        #region cUser
        public static void cUser_Insert(string username, string stripeKey)
        {
            (new C4GEntities()).cUser_Insert(username, stripeKey);
        }

        public static cUser cUser_GetByName(string username)
        {
            return (new C4GEntities()).cUser_GetByName(username).FirstOrDefault<cUser>();
        }
        #endregion
        #region DealInstance
        public static List<DealInstance> DealInstance_List()
        {
            return (new C4GEntities()).DealInstance_List().ToList<DealInstance>();
        }
        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<Deals_ListforSearchGrid_Result> DealInstance_ListByCity(string cityCode, string politicalDivision, string country)
        {
            return (new C4GEntities()).Deals_ListforSearchGrid(cityCode, politicalDivision, country).ToList<Deals_ListforSearchGrid_Result>();
        }

        public static DealInstance DealInstance_GetByID(int DealInstanceID)
        {
            return (new C4GEntities()).Deal_GetByID(DealInstanceID).FirstOrDefault<DealInstance>();
        }

        public static List<DealInstance> DealInstance_ListByMerchant(int MerchantID)
        {
            return new C4GEntities().DealInstance_ListByMerchant(MerchantID).ToList<DealInstance>();
        }

        public static DealInstance DealInstance_GetByDealName(string dealName, int merchantID)
        {
            return new C4GEntities().DealInstance_GetByDealName(dealName, merchantID).FirstOrDefault<DealInstance>();
        }
        #endregion
        #region Merchant
        public static List<Merchant> ListGlobalPartnersByNPO(string username)
        {
            return new C4GEntities().Merchant_ListGlobalPartnersByNPO(username).ToList<Merchant>();
        }

        public static List<Merchant> ListLocalPartnersByNPO(string username)
        {
            return new C4GEntities().Merchant_ListLocalPartnersByNPO(username).ToList<Merchant>();
        }
        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<Merchant> Mechant_ListByCity(int cityCode)
        {
            return (new C4GEntities()).Merchant_ListByCity(cityCode).ToList<Merchant>();
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<Merchant> Merchant_ListGlobal()
        {
            return (new C4GEntities()).Merchant_ListGlobal().ToList<Merchant>();
        }

        public static Merchant Merchant_Get(int MerchantID)
        {
            return (new C4GEntities()).Merchant_Get(MerchantID).FirstOrDefault<Merchant>();
        }

        public static bool Merchant_ApproveRequest(int merchantID, int npoid)
        {
            bool result = false;

            string r = (new C4GEntities()).Merchant_ApproveRequest(merchantID, npoid).FirstOrDefault<String>();

            if (r == "Request Expired")
                result = false;
            else if (r == "Request accepted!")
                result = true;

            return result;
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<ListPendingMerchants_Result> ListPendingMerchants()
        {
            return (new C4GEntities()).ListPendingMerchants().ToList<ListPendingMerchants_Result>();
        }

        public static void Merchant_Approve(int MerchantID)
        {
            (new C4GEntities()).Merchant_Approve(MerchantID);
        }

        public static void Merchant_ApproveAllPending()
        {
            new C4GEntities().Merchant_ApproveAllPending();
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<Merchant> Merchant_GetFeatured()
        {
            return new C4GEntities().Merchant_GetFeatured().ToList<Merchant>();
        }

        public static Merchant Merchant_GetByName(string name)
        {
            return new C4GEntities().Merchant_GetByName(name).FirstOrDefault<Merchant>();
        }
        #endregion
        #region MerchantInfo
        public static void MerchantInfo_Insert(string Username, string Name, string phoneNumber, string description)
        {
            new C4GEntities().MerchantInfo_Insert(Username, Name, phoneNumber, description);
        }

        public static MerchantInfo MerchantInfo_Get(string username)
        {
            return new C4GEntities().MerchantInfo_Get(username).FirstOrDefault<MerchantInfo>();
        }
        #endregion
        #region MerchantStripeInfo
        public static MerchantStripeInfo MerchantStripeInfo_Get(int merchantID)
        {
            return (new C4GEntities()).MerchantStripeInfo_Get(merchantID).FirstOrDefault<MerchantStripeInfo>();
        }

        public static void MerchantStripeInfo_Insert(int merchantID, string apiKey)
        {
            (new C4GEntities()).MerchantStripeInfo_Insert(merchantID, apiKey);
        }
        #endregion
        #region Newsletter User
        public static void NewsletterUser_Signup(string email)
        {
            (new C4GEntities()).NewsletterUser_Signup(email);
        }
        #endregion
        #region NPO
        public static NPO NPO_GetByUrl(string Url)
        {
            return (new C4GEntities().NPO_GetByURL(Url)).FirstOrDefault<NPO>();
        }

        public static bool NPO_HasCampaign(int NPOID)
        {
            if ((new C4GEntities()).NPO_HasCampaign(NPOID).FirstOrDefault().ToString() == "1")
                return true;
            else
                return false;
        }

        public static void NPO_InsertMerchantPartner(int MerchantID, string username)
        {
            (new C4GEntities()).NPO_AddMerchantPartner(MerchantID, username);
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<ListPendingNPOs_Result> ListPendingNPOs()
        {
            return (new C4GEntities()).ListPendingNPOs().ToList<ListPendingNPOs_Result>();
        }

        public static NPO NPO_Get(int NPOID)
        {
            return (new C4GEntities()).NPO_Get(NPOID).FirstOrDefault<NPO>();
        }

        public static void NPO_Approve(int NPOID)
        {
            new C4GEntities().NPO_Approve(NPOID);
        }

        public static void NPO_ApproveAllPending()
        {
            new C4GEntities().NPO_ApproveAllPending();
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<NPO> NPO_GetFeatured()
        {
            return new C4GEntities().NPO_GetFeatured().ToList<NPO>();
        }
        #endregion
        #region NPOcUser
        public static void NPOcUser_Insert(string username, int npoid)
        {
            (new C4GEntities()).NPOcUser_Insert(username, npoid);
        }
        #endregion
        #region PaymentOptions
        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<PaymentOption_ListByUser_Result> PaymentOptions_ListByUser(string username)
        {
            return (new C4GEntities()).PaymentOption_ListByUser(username).ToList<PaymentOption_ListByUser_Result>();
        }

        public static void PaymentOptions_Insert(string username, int cardTypeID, string last4Digits, string stripeToken,
            string address, string city, string province, string postal, string country)
        {
            (new C4GEntities()).PaymentOption_Insert(username, cardTypeID, last4Digits.ToString(), stripeToken,
                address, city, province, postal, country);
        }

        public static PaymentOption PaymentOption_Get(int PaymentOptionID)
        {
            return (new C4GEntities()).PaymentOption_Get(PaymentOptionID).FirstOrDefault<PaymentOption>();
        }

        public static void PaymentOption_Delete(int poid)
        {
            (new C4GEntities()).PaymentOption_Delete(poid);
        }
        #endregion
        #region PreferredCity
        public static void PreferredCity_Insert(int cityID, string username)
        {
            (new C4GEntities()).PreferredCity_InsertOrUpdate(username, cityID);
        }
        #endregion
        #region Price
        public static Price Price_GetByDealInstance(int dealInstanceID)
        {
            return (new C4GEntities()).Price_GetByDealInstance(dealInstanceID).FirstOrDefault<Price>();
        }
        #endregion
        #region PurchaseOrders
        public static List<PurchaseOrder> PurchaseOrder_Insert(List<ShoppingCart> orders, string user)
        {
            List<PurchaseOrder> result = new List<PurchaseOrder>();

            C4GEntities en = new C4GEntities();
            int transactionID = -1;

            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    transactionID = en.PurchaseTransaction_Insert(user).FirstOrDefault() ?? -1;
                    
                    if (transactionID == -1)
                        throw new Exception("Purchase Transaction failed to save.");

                    foreach (ShoppingCart item in orders)
                    {
                        result.Add(en.PurchaseOrder_Insert(item.DealInstanceID, item.CampaignID, transactionID, item.GiftValue, (decimal)item.Split.NPOSplit,
                           (decimal)item.Split.MerchantSplit, (decimal)item.Split.OurSplit).FirstOrDefault<PurchaseOrder>());
                    }

                    ts.Complete();
                }
                catch (Exception ex)
                {
                    try
                    {
                        ex.ToString();
                        ts.Dispose();
                    }
                    catch (Exception ex2)
                    {
                        ex2.ToString();
                        ts.Dispose();
                    }
                }
            }

            return result;
        }
        #endregion
        #region Theme
        public static Theme Theme_GetByNPO(int NPOID)
        {
            return (new C4GEntities()).Theme_GetByNPO(NPOID).FirstOrDefault<Theme>();
        }

        public static void Theme_Insert(string Username, string Name, string Description, string Content, bool Active)
        {
            (new C4GEntities()).Theme_Insert(Name, Username, Description, Content, Active);
        }
        
        public static bool Theme_HasActive(string username)
        {
            if ((new C4GEntities()).Theme_HasActive(username).ToString() == "1")
                return true;
            else
                return false;
        }

        public static void Theme_SetActive(int ThemeID, string UserName)
        {
            (new C4GEntities()).Theme_SetAsActive(UserName, ThemeID);
        }

        public static List<Theme> Theme_ListByUser(string username)
        {
            return (new C4GEntities()).Theme_ListByUser(username).ToList<Theme>();
        }

        public static Theme Theme_Get(int ThemeID)
        {
            return (new C4GEntities()).Theme_Get(ThemeID).FirstOrDefault<Theme>();
        }

        public static void Theme_Update(int ThemeID, string name, string desc, string content)
        {
            (new C4GEntities()).Theme_Update(ThemeID, name, desc, content);
        }
        #endregion
    }
}

namespace CouponsForGiving.Data.Classes
{
    public static class Campaigns
    {
        public static List<Campaign> List()
        {
            return new C4GEntities().Campaign_List().ToList<Campaign>();
        }

        public static List<Campaign> ListByCity(string city, string province)
        {
            return new C4GEntities().Campaign_ListByCity(city, province).ToList<Campaign>();
        }

        public static void MarkAsActive(int CampaignID)
        {
            new C4GEntities().Campaign_MarkAsActive(CampaignID);
        }

        public static int Save(string username, string name, DateTime? startDate, DateTime? enddate, string campaigndescription, int? fundraisinggoal,
            string campaignimage, bool? showonhome, int? displaypriority, string campaigngoal)
        {
            return new C4GEntities().Campaign_Save(null, username, name, startDate, enddate, campaigndescription, fundraisinggoal, campaignimage,
                showonhome, displaypriority, campaigngoal).FirstOrDefault<int?>() ?? default(int);
        }

        public static int Save(int campaignID, string username, string name, DateTime? startDate, DateTime? enddate, string campaigndescription,
            int? fundraisinggoal, string campaignimage, bool? showonhome, int? displaypriority, string campaigngoal)
        {
            return new C4GEntities().Campaign_Save(campaignID, username, name, startDate, enddate, campaigndescription, fundraisinggoal, campaignimage,
                showonhome, displaypriority, campaigngoal).FirstOrDefault<int?>() ?? default(int);
        }

        public static List<string> IsComplete(int CampaignID)
        {
            return new C4GEntities().Campaign_IsComplete(CampaignID).FirstOrDefault<String>().Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries).ToList<string>();
        }

        public static List<Campaign> ListActiveByUsername(string username)
        {
            return new C4GEntities().Campaign_ListActiveByUsername(username).ToList<Campaign>();
        }

        public static List<Campaign> ListInactiveByUsername(string username)
        {
            return new C4GEntities().Campaign_ListIncompleteByUsername(username).ToList<Campaign>();
        }

        public static void UpdateImage(int CampaignID, string ImagePath)
        {
            new C4GEntities().Campaign_UpdateImage(CampaignID, ImagePath);
        }

        public static List<Campaign> ListAllByUsername(string username)
        {
            return new C4GEntities().Campaign_ListByNPO(username).ToList<Campaign>();
        }

        public static List<Campaign> ListByDeal(int DealID)
        {
            return new C4GEntities().Campaign_ListByDeal(DealID).ToList<Campaign>();
        }
    }

    public static class CampaignDealInstances
    {
        /// <summary>
        /// Inserts a new record if it doesn't exist.
        /// </summary>
        /// <param name="CampaignID">The ID of the campaign to insert.</param>
        /// <param name="DealInstanceID">The ID of the deal instance to insert.</param>
        /// <returns>True if a new record was inserted, false if it existed already.</returns>
        public static bool InsertIfNotExists(int CampaignID, int DealInstanceID)
        {
            if (new C4GEntities().CampaignDealInstance_InsertIfNotExists(CampaignID, DealInstanceID).FirstOrDefault<String>() == "yes")
                return true;
            else
                return false;
        }

        public static void Remove(int CampaignID, int DealInstanceID)
        {
            new C4GEntities().CampaignDealInstance_Remove(DealInstanceID, CampaignID);
        }

        public static bool Exists(int CampaignID, int DealInstanceID)
        {
            bool result = false;

            result = bool.Parse(new C4GEntities().CampaignDealInstance_Exists(CampaignID, DealInstanceID).FirstOrDefault<string>());

            return result;
        }
    }

    public static class Cities
    {
        public static City Get(int CityID)
        {
            return new C4GEntities().City_Get(CityID).FirstOrDefault<City>();
        }

        public static City GetByName(string name, string provinceCode, string countryCode)
        {
            return new C4GEntities().City_GetByName(name, provinceCode, countryCode).FirstOrDefault<City>();
        }

        public static City GetByNameWithProvinceAndCountry(string name, string province, string country)
        {
            return new C4GEntities().City_GetByNameWithProvinceAndCountry(name, province, country).FirstOrDefault<City>();
        }

        public static List<City> List()
        {
            return new C4GEntities().Cities_ListWhereActiveDeals().ToList<City>();
        }

        public static List<City> ListAll()
        {
            return new C4GEntities().Cities_List().ToList<City>();
        }
    }

    public static class Countries
    {
        public static List<Country> List()
        {
            return new C4GEntities().Countries_List().ToList<Country>();
        }
    }

    public static class cUsers
    {
        public static List<cUser> List()
        {
            return new C4GEntities().Users_List().ToList<cUser>();
        }
    }

    public static class Deals
    {
        public static List<string> ListNamesByMerchant(string Username)
        {
            return new C4GEntities().Deal_ListNamesByMerchant(Username).ToList<string>();
        }

        public static List<Deal_GetEligibleByUsername_Result> GetEligibleByUsername(string username, DateTime endDate)
        {
            return new C4GEntities().Deal_GetEligibleByUsername(username, endDate).ToList<Deal_GetEligibleByUsername_Result>();
        }

        public static List<DealInstance> ListByCity(string city, string province)
        {
            return new C4GEntities().Deal_ListByCity(city, province).ToList<DealInstance>();
        }

        public static int Insert(int merchantID, string name, string description,
            int absoluteCouponLimit, int limitPerCustomer, string image)
        {
            return (new C4GEntities()).Deal_Insert(merchantID, name, description,
                absoluteCouponLimit, limitPerCustomer, image).FirstOrDefault() ?? -1;
        }

        public static void Update(int dealID, int merchantID, string name, string description,
            int absoluteCouponLimit, int limitPerCustomer, string image)
        {
            new C4GEntities().Deal_Update(dealID, merchantID, name, description,
                absoluteCouponLimit, limitPerCustomer, image);
        }
    }

    public static class DealInstances
    {
        public static List<DealInstance> ListAllByMerchant(string username)
        {
            return new C4GEntities().DealInstance_ListAllByMerchant(username).ToList<DealInstance>();
        }

        public static List<DealInstance> ListForGlobalMarketplace()
        {
            return new C4GEntities().DealInstance_ListForGlobalMarketplace().ToList<DealInstance>();
        }
    }

    public static class FinePrints
    {
        public static List<FinePrint> List()
        {
            return new C4GEntities().FinePrint_List().ToList<FinePrint>();
        }

        public static List<FinePrint> List(int DealID)
        {
            return new C4GEntities().FinePrint_ListByDeal(DealID).ToList<FinePrint>();
        }

        public static void Add (int DealID, int FinePrintID)
        {
            new C4GEntities().FinePrint_AddToDeal(DealID, FinePrintID);
        }

        public static void Remove(int DealID, int FinePrintID)
        {
            new C4GEntities().Deal_FinePrint_Remove(DealID, FinePrintID);
        }
    }

    public static class MerchantNPO
    {
        public static List<Merchant> ListEligiblePartnersByNPO(string username, int cityID)
        {
            return new C4GEntities().Merchant_ListEligiblePartnersByNPO(username, cityID).ToList<Merchant>();
        }

        public static List<Merchant> ListEligibleGlobalPartnersByNPO(string username)
        {
            return new C4GEntities().Merchant_ListEligibleGlobalPartnersByNPO(username).ToList<Merchant>();
        }
    }

    public static class Merchants
    {
        public static Merchant GetByUsername(string Username)
        {
            return new C4GEntities().Merchant_GetByUsername(Username).FirstOrDefault<Merchant>();
        }
        
        public static List<string> ListNames()
        {
            return new C4GEntities().Merchant_ListNames().ToList<string>();
        }

        public static List<Merchant> ListPartnersByNPO(string username)
        {
            return new C4GEntities().Merchant_ListPartnersByNPO(username).ToList<Merchant>();
        }

        public static List<NPO> ListNPORequests(string username)
        {
            return (new C4GEntities().Merchant_ListNPORequests(username)).ToList<NPO>();
        }

        public static void ApproveNPORequest(string username, int NPOID)
        {
            new C4GEntities().Merchant_ApproveNPORequest(username, NPOID);
        }

        public static void RemoveNPOPartner(string username, int merchantID)
        {
            C4GEntities e = new C4GEntities();
            e.RemovePartnership(e.NPO_GetByUser(username).FirstOrDefault<NPO_GetByUser_Result>().NPOID, merchantID);
        }

        public static void AddNPOPartner(int NPOID, int MerchantID)
        {
            new C4GEntities().Merchant_InsertNPOPartner(MerchantID, NPOID);
        }
    }

    public static class NotificationcUsers
    {
        public static List<Notification> ListByUser(string Username)
        {
            return new C4GEntities().NotificationcUser_List(Username).ToList<Notification>();
        }

        public static void Insert(string NotificationCode, string Username)
        {
            new C4GEntities().NotificationcUser_Insert(Username, NotificationCode);
        }

        public static void Delete(string NotificationCode, string Username)
        {
            new C4GEntities().NotificationcUser_Delete(NotificationCode, Username);
        }
    }

    public static class NPOs
    {
        public static List<NPO> List()
        {
            return new C4GEntities().NPO_List().ToList<NPO>();
        }

        public static void ApproveMerchantRequest(string username, int merchantID)
        {
            new C4GEntities().NPO_ApproveMerchantRequest(username, merchantID);
        }

        public static List<Merchant> ListMerchantRequests(string username)
        {
            return new C4GEntities().NPO_ListMerchantRequests(username).ToList<Merchant>();
        }

        public static void RemoveMerchantPartner(string username, int NPOID)
        {
            C4GEntities e = new C4GEntities();
            e.RemovePartnership(e.Merchant_GetByUsername(username).FirstOrDefault<Merchant>().MerchantID, NPOID);
        }

        public static List<NPO> ListPartnersByMerchant(string username)
        {
            return new C4GEntities().NPO_ListNPOPartners(username).ToList<NPO>();
        }

        public static NPO NPO_GetByUser(string Username)
        {
            return new C4GEntities().NPO_GetByUsername(Username).FirstOrDefault<NPO>();
        }

        public static bool HasMerchantPartners(string Username)
        {
            return (new C4GEntities().NPO_HasPartners(Username).First() == 1) ? true : false;
        }

        public static void AddMerchantPartner(int NPOID, int MerchantID)
        {
            new C4GEntities().NPO_InsertMerchantPartner(MerchantID, NPOID);
        }
    }

    [DataObject]
    public static class NPOMerchants
    {
        public static List<NPO> ListEligiblePartnersByMerchant(string username)
        {
            return new C4GEntities().NPO_ListEligiblePartnersByMerchant(username).ToList<NPO>();
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<Merchant> ListForNPO(string username, int cityCode)
        {
            return new C4GEntities().Merchant_ListForNPO(username, cityCode).ToList<Merchant>();
        }
    }

    public static class NPOSettings
    {
        public static NPOSetting Get (int NPOID)
        {
            return new C4GEntities().NPOSetting_Get(NPOID).FirstOrDefault<NPOSetting>();
        }

        public static void Insert(int NPOID, bool AutoAcceptMerchantRequests)
        {
            new C4GEntities().NPOSetting_Insert(NPOID, AutoAcceptMerchantRequests);
        }

        public static void Update(string username, bool AutoAcceptMerchantRequests)
        {
            new C4GEntities().NPOSettings_Update(username, AutoAcceptMerchantRequests);
        }
    }

    public static class MerchantSettings
    {
        public static MerchantSetting GetByMerchant(int MerchantID)
        {
            return new C4GEntities().MerchantSettings_GetByMerchantID(MerchantID).FirstOrDefault<MerchantSetting>();
        }

        public static MerchantSetting GetByMerchant(string username)
        {
            return new C4GEntities().MerchantSetting_GetByMerchant(username).FirstOrDefault<MerchantSetting>();
        }

        public static void Insert(int merchantID, bool autoApproveRequests)
        {
            new C4GEntities().MerchantSetting_Insert(merchantID);
        }

        public static void Update(int merchantID, bool autoApproveRequests)
        {
            new C4GEntities().MerchantSetting_Update(merchantID, autoApproveRequests);
        }

        //Setting-specific methods
        public static bool AcceptsAllRequests(int MerchantID)
        {
            bool? result = GetByMerchant(MerchantID).AutoAcceptRequests;
            return result.HasValue ? (bool)result : false;
        }
    }

    public static class Provinces
    {
        public static List<PoliticalDivision> List(string countryCode)
        {
            return new C4GEntities().Provinces_ListByCountry(countryCode).ToList<PoliticalDivision>();
        }
    }

    public static class PurchaseOrders
    {
        public static List<PurchaseOrder> ListByMerchant(string Username)
        {
            return new C4GEntities().PurchaseOrder_ListByMerchant(Username).ToList<PurchaseOrder>();
        }

        public static List<PurchaseOrder> ListActiveByMerchant(string username)
        {
            return new C4GEntities().PurchaseOrder_ListUnredeemedByMerchant(username).ToList<PurchaseOrder>();
        }

        public static void Redeem(int PurchaseOrderID)
        {
            new C4GEntities().PurchaseOrder_Redeem(PurchaseOrderID);
        }

        public static void Unredeem(int PurchaseOrderID)
        {
            new C4GEntities().PurchaseOrder_Unredeem(PurchaseOrderID);
        }

        public static List<PurchaseOrder> ListUnredeemedByUser(string Username)
        {
            return new C4GEntities().PurchaseOrder_ListUnredeemedByUser(Username).ToList<PurchaseOrder>();
        }

        public static List<PurchaseOrder> ListRedeemedByUser(string Username)
        {
            return new C4GEntities().PurchaseOrder_ListRedeemedByUser(Username).ToList<PurchaseOrder>();
        }

        public static void RedeemByCouponCode(Guid couponCode)
        {
            new C4GEntities().PurchaseOrder_RedeemByCouponCode(couponCode);
        }

        public static PurchaseOrder Get(Guid couponCode)
        {
            return new C4GEntities().PurchaseOrder_GetByCouponCode(couponCode).FirstOrDefault<PurchaseOrder>();
        }

        public static PurchaseOrder Get(int PurchaseOrderID)
        {
            return new C4GEntities().PurchaseOrder_GetByID(PurchaseOrderID).FirstOrDefault<PurchaseOrder>();
        }

        public static List<PurchaseOrder> List()
        {
            return new C4GEntities().PurchaseOrder_List().ToList<PurchaseOrder>();
        }
    }

    public static class Story
    {
        public static List<News> List()
        {
            return new C4GEntities().News_List().ToList<News>();
        }

        public static List<News> List(DateTime Month)
        {
            return new C4GEntities().News_ListByMonth(Month).ToList<News>();
        }

        public static void Add(string name, string content)
        {
            new C4GEntities().News_Insert(name, content);
        }

        public static void Edit(int NewsID, string name, string content)
        {
            new C4GEntities().News_Edit(NewsID, name, content);
        }

        public static void Delete(int NewsID)
        {
            new C4GEntities().News_Delete(NewsID);
        }
    }
}
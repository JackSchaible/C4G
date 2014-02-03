using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class PurchaseSplit
{
    public float MerchantSplit { get; set; }
    public float NPOSplit { get; set; }
    public float OurSplit { get; set; }
    public float StripeFee { get; set; }
    public float Tax { get; set; }

    private const float MerchantPercentage = 0.55F;
    private const float NPOPercentage = 0.25F;
    private const float OurPercentage = 0.2F;

    public PurchaseSplit(decimal GiftValue)
    {
        float giftValue = (float)GiftValue;

        StripeFee = (giftValue * 0.029F) + 0.3F;
        Tax = ((OurPercentage * giftValue) * 0.05F);
        MerchantSplit = (MerchantPercentage * giftValue) - Tax;
        NPOSplit = NPOPercentage * giftValue;
        OurSplit = (OurPercentage * giftValue) + Tax;
    }
}

public class ShoppingCart
{
    public string NPOName { get; set; }
    public int CampaignID { get; set; }
    public string CampaignName { get; set; }
    public int DealInstanceID { get; set; }
    public string DealName { get; set; }
    public int MerchantID { get; set; }
    public string MerchantName { get; set; }
    public decimal GiftValue { get; set; }
    public decimal RetailValue { get; set; }
    public PurchaseSplit Split { get; set; }

    public ShoppingCart(string npo, int campaignid, string campaign, int dealinstanceid, string deal, 
        int merchantid, string merchant, decimal giftvalue, decimal retailvalue)
    {
        NPOName = npo;
        CampaignID = campaignid;
        CampaignName = campaign;
        DealInstanceID = dealinstanceid;
        DealName = deal;
        MerchantID = merchantid;
        MerchantName = merchant;
        GiftValue = giftvalue;
        RetailValue = retailvalue;
        Split = new PurchaseSplit(giftvalue);
    }
}
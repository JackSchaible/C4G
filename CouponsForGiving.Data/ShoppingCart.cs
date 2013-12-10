using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ShoppingCart
/// </summary>
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
    public decimal NPOSplit { get; set; }
    public decimal MerchantSplit { get; set; }
    public decimal OurSplit { get; set; }

    public const decimal NPOSplitPerc = 0.25M;
    //Important: MerchantSplit = 55% - (2.3% VAT + 5% GST on GenerUS fee (20%))
    public const decimal MerchantSplitPerc = 0.55M - (0.023M + 0.01M);
    public const decimal OurSplitPerc = 1 - (NPOSplitPerc + MerchantSplitPerc);

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

        //Calculate the proper splits
        NPOSplit = NPOSplitPerc * GiftValue;
        MerchantSplit = MerchantSplitPerc * GiftValue;
        OurSplit = OurSplitPerc * GiftValue;
    }
}
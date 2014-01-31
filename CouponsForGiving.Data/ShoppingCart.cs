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
    //Important: MerchantSplit = 54% - (2.9% Processing Fee + $0.30 + 5% GST on GenerUS fee (21%))
    public const decimal MerchantSplitPerc = 0.55M;
    public const decimal OurSplitPerc = 0.2M;

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
        decimal vat = (GiftValue * 0.029M) + 0.3M;
        decimal tax = (GiftValue * 0.2M) * 0.05M;
        decimal split = (GiftValue * 0.55M) - (vat + tax);
        NPOSplit = GiftValue * NPOSplitPerc;
        MerchantSplit = (GiftValue * 0.55M) - (tax + vat); ;
        OurSplit = (GiftValue * 0.2M) + tax;
    }
}
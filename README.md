## AppSpin: iOS ##
#### Helper classes for implementation ####
----------

This is a very simple implementation example for an **AppSpin** campaign. User action triggers `ASReferral` to check for campaigns for the specified app. 

If a campaign exists, the user is presented with the offer via a system `UIView`. If they choose to participate, we launch the browser to display the campaign details.

The quickest implementations rely on our *white-labeled* webservice to display reward details, tracking links, etc. However, all data can be displayed natively to preserve branding and consistent UX

#### **Requirements** ####

 - The `ASReferral` helper class should be compatible from iOS **Version 6.1** onward
 - The helper class must be compiled with **ARC**

#### **Usage** ####

Within the relevant `ViewController`:

    _theReferral = [[ASReferral alloc] init];
    [_theReferral checkForOffers];
    
Within the `ViewController` header:

    #import "ASReferral.h"
    ...
    @property ASReferral *theReferral;


If there aren't any offers or the campaigns have been stopped in the Admin Panel, the check will simply `return`.

#### **Notes** ####

 - Don't just display the offer immediately! Choose a behavioral `hook` in your application to initiate the campaign and then check for offers, e.g.

    - The second day the app is used
    - The first level or task has been completed
    - They click an '*Earn Rewards*' button in your menu
    
 - Use `Localizable.strings` to make offer messages easier to localize for internationally available apps

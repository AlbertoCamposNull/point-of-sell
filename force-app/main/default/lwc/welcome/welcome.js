import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import LOGO from '@salesforce/resourceUrl/logo';


export default class Welcome extends NavigationMixin(LightningElement) {
    logoUrl = LOGO;
    handleClick(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'PointOfSellPage__c',
            }
        });
    }
}
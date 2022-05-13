import { LightningElement, api, wire } from 'lwc';
import getItems from '@salesforce/apex/ItemController.getItems';
import { NavigationMixin } from 'lightning/navigation';


export default class ItemsList extends NavigationMixin(LightningElement) {
    @wire(getItems) items;
    @api recordId;
    handleClick(event){
        this.recordId = String(event.target.id).substring(0, 18);
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'ItemDetailsPage__c',
            }, 
            state:{
                Id: this.recordId
            } 
        });
    }
}

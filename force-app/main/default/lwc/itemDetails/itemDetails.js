import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getItem from '@salesforce/apex/ItemController.getItem';
import addPurchase from '@salesforce/apex/PurchaseController.addPurchase';
import getCustomers from '@salesforce/apex/ContactController.getCustomers';


export default class ItemDetails extends NavigationMixin(LightningElement) {
    currentPageReference = null; 
    urlStateParameters = null;
    recordId;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
       }
    }
 
    setParametersBasedOnUrl() {
       this.recordId = String(this.urlStateParameters.Id || null);
    }
    
    @wire (getItem, {itemId: '$recordId'}) record;
    @wire (getCustomers) customers;
    @track customerId;
    @track isModalOpen = false;

    closeModal() {
      this.isModalOpen = false;
      this[NavigationMixin.Navigate]({
          type: 'comm__namedPage',
          attributes: {
              name: 'PointOfSellPage__c',
          }
      });
  }

    get options() {
      var element = [];
          for (let index = 0; index < this.customers.data.length; index++) {  
               element.push({ label: this.customers.data[index].FirstName + ' ' + this.customers.data[index].LastName, value: this.customers.data[index].Id });
          }
      return element;
  }


    buyClick(){
      addPurchase({ itemId: this.recordId, customerId: this.customerId })
            .then(() => {
               this.isModalOpen = true;
            }).catch(error => {
               this.dispatchEvent(
                  new ShowToastEvent({
                     title:'Error',
                     message: 'error: ' + error.body,
                     variant: 'error',
                  })
                );
            });
   }

    handleComboboxChange(event){
       this.customerId = event.detail.value;
    }
}  
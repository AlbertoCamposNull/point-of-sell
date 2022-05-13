import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getItems from '@salesforce/apex/ItemController.getItems';
import { NavigationMixin } from 'lightning/navigation';

export default class ProductInformationForm extends NavigationMixin(LightningElement) {
    currentPageReference = null; 
    urlStateParameters = null;
    firstName;
    lastName;
    phone;
    email;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
       }
    }
 
    setParametersBasedOnUrl() {
       this.firstName = String(this.urlStateParameters.firstName || null);
       this.lastName = String(this.urlStateParameters.lastName || null);
       this.phone = this.urlStateParameters.phone || null;
       this.email = this.urlStateParameters.email || null;
    }
    
    @track sku;

    @wire (getItems) items;

    get options() {
      var element = [];
          for (let index = 0; index < this.items.data.length; index++) {  
               element.push({ label: this.items.data[index].Name, value: this.items.data[index].SKU__c });
          }
      return element;
  }

  handleComboboxChange(event){
   this.sku = event.detail.value;
}

handleNextClick(event){
   this[NavigationMixin.Navigate]({
       type: 'comm__namedPage',
       attributes: {
           name: 'ReciveComplaintPage__c',
       }, 
       state:{
           firstName: this.firstName,
           lastName: this.lastName,
           phone: this.phone,
           email: this.email,
           SKU: this.sku
       } 
   });
}

}
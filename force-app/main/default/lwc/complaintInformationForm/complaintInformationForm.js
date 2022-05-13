import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import addCase from '@salesforce/apex/CaseController.addCase';

export default class ComplaintInformationForm extends NavigationMixin(LightningElement) {
    currentPageReference = null; 
    urlStateParameters = null;
    firstName;
    lastName;
    phone;
    email;
    sku;
    @track subject;
    @track description;
    @track street;
    @track city;
    @track country;
    @track province;
    @track postalCode;

    @track isModalOpen = false;
    @track caseNumber;

    closeModal() {
        this.isModalOpen = false;
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home',
            }
        });
    }


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
       this.sku = this.urlStateParameters.SKU || null;
    }

    handleSubjectChange(event){
        this.subject = event.target.value;
    }

    handleDescriptionChange(event){
        this.description = event.target.value;
    }

    handleAddressChange(event){
        this.street = event.target.street;
        this.city = event.target.city;
        this.country = event.target.country;
        this.province = event.target.province;
        this.postalCode = event.target.postalCode;
    }

    obj = null;
    handleCreateCaseClick(event){
        this.obj = {
            firstName: this.firstName,
            lastName: this.lastName,
            phone: this.phone,
            email: this.email,
            sku: this.sku,
            subject: this.subject,
            description: this.description,
            street: this.street,
            city: this.city,
            country: this.country,
            province: this.province,
            postalCode: this.postalCode

        };
        console.log(this.obj);
        addCase({ json: JSON.stringify(this.obj) })
            .then(result => {
                this.caseNumber = result;
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
}
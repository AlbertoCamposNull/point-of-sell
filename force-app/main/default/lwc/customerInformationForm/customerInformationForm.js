import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CustomerInformationForm extends NavigationMixin(LightningElement) {
    fieldsList = ['firstName', 'lastName'];

    get fields() {
        return this.fieldsList;
    }
    @track firstName;
    @track lastName;
    @track phone;
    @track email;

    handleNameChange(event) {
        this.firstName = event.target.firstName;
        this.lastName = event.target.lastName;
    }

    handlePhoneChange(event){
        this.phone = event.target.value;
    }

    handleEmailChange(event){
        this.email = event.target.value;
    }

    handleNextClick(event){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'ComplaintProductPage__c',
            }, 
            state:{
                firstName: this.firstName,
                lastName: this.lastName,
                phone: this.phone,
                email: this.email
            } 
        });
    }

}
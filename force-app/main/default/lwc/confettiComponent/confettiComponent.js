/**
 * Created by r.dzhus on 09.12.2024.
 */
import { LightningElement, track } from 'lwc';
import { subscribe, onError } from 'lightning/empApi';
import { loadScript } from 'lightning/platformResourceLoader';
import CANVAS_CONFETTI from '@salesforce/resourceUrl/canvasConfetti';

export default class ConfettiComponent extends LightningElement {
    @track toastMessage = '';
    @track showToast = false;

    channelName = '/event/Application_Stage_Change__e';
    canvasConfetti; // Confetti instance

    async connectedCallback() {
        try {
            // Load canvas-confetti from Static Resources
            await loadScript(this, CANVAS_CONFETTI);
            console.log('Canvas confetti library loaded.');
            this.canvasConfetti = window.confetti;
        } catch (error) {
            console.error('Error loading canvas-confetti:', error);
        }

        this.subscribeToPlatformEvent();
    }

    subscribeToPlatformEvent() {
        subscribe(this.channelName, -1, (message) => {
            const { Candidate_Full_Name__c, Job_Requisition_Title__c, Account_Name__c } = message.data.payload;

            // Create the message for the toast
            this.toastMessage = `Great news! ${Candidate_Full_Name__c} started a new position as ${Job_Requisition_Title__c} for ${Account_Name__c}.`;

            this.showCustomToastWithConfetti();
        }).then((response) => {
            console.log('Subscribed to platform event:', response);
        }).catch((error) => {
            console.error('Error subscribing to platform event:', error);
        });

        onError((error) => {
            console.error('Error in platform event subscription:', error);
        });
    }

    showCustomToastWithConfetti() {
        this.showToast = true;
        this.launchConfetti();

        // Hide the custom toast after 3 seconds
        setTimeout(() => {
            this.showToast = false;
        }, 3000);
    }

    launchConfetti() {
        if (this.canvasConfetti) {
            // Fire confetti with adjusted decay for a 3-second animation
            this.fire(0.25, { spread: 26, startVelocity: 55, decay: 0.94, ticks: 300 });
            this.fire(0.2, { spread: 60, decay: 0.94, ticks: 300 });
            this.fire(0.35, { spread: 100, decay: 0.94, scalar: 0.8, ticks: 300 });
            this.fire(0.1, { spread: 120, startVelocity: 25, decay: 0.94, scalar: 1.2, ticks: 300 });
            this.fire(0.1, { spread: 120, startVelocity: 45, decay: 0.94, ticks: 300 });
        } else {
            console.error('Canvas confetti is not accessible.');
        }
    }

    fire(particleRatio, opts) {
        this.canvasConfetti({
            ...opts,
            particleCount: Math.floor(200 * particleRatio),
            origin: { y: 0.7 }
        });
    }
}

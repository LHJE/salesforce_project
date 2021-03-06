@istest public class BandMerch_test {
    @TestSetup static void setup() {
        Merch__c item1 = new Merch__c(name = 'LP', Description__c = 'record', Price__c = 15);
        Merch__c item2 = new Merch__c(name = 'hat', Description__c = 'trucker', Price__c = 10);
        insert new Merch__c[] { item1, item2 };
    }

    @istest static void testInitialState() {
        BandMerch controller = new BandMerch();
        Merch__c[] merch = [SELECT id FROM Merch__c];
        system.assertequals('inital state', controller.state);
        system.assertequals(merch.size(), controller.items.size());
        system.assert(controller.items.size() > 0);
        for (BandMerch.Item item : controller.items) {
            system.assertnotequals(null, item.merch);
            system.assertequals(0, item.quantity);
            system.assertequals(0, item.subtotal);
            item.quantity = 1;
            system.assert(item.subtotal > 0);
            system.assertequals(item.quantity * item.merch.price__c, item.subtotal);
        }
        controller.items[0].addedQuantity = 2;
    }

    @istest static void itemFunctionality () {
        BandMerch controller = new BandMerch();
        system.assert(controller.items.size() > 0);
        // test add method increases quantity correctly
        controller.items[0].addedQuantity = 2;
        system.assertequals(0, controller.items[0].quantity);
        test.starttest();
        controller.items[0].add();
        test.stoptest();
        system.assertequals(2, controller.items[0].quantity);
        //test quantity doesn't return negative numbers
        controller.items[0].quantity = -3;
        system.assertequals(0, controller.items[0].quantity);
    }
}

import XyBleSdk

/// All available services + getters based on names or uuids
final internal class XYServiceRegistry {

    static private let registry: [String: XYServiceCharacteristic.Type] = [
        "Alert Notification": AlertNotificationService.self,
        "Basic Config": BasicConfigService.self,
        "Battery": BatteryService.self,
        "Control": ControlService.self,
        "Primary": XYFinderPrimaryService.self,
        "Device Information": DeviceInformationService.self,
        "Extended Config": ExtendedConfigService.self,
        "ExtendedControlService": ExtendedControlService.self
    ]

    // Get by name
    class func from(service servName: String, characteristic charName: String) -> XYServiceCharacteristic? {
        guard
            let service = self.registry[servName],
            let servChar = service.values.first(where: { $0.displayName == charName })
            else {
                return nil
            }

        return servChar
    }

    // Get from serv/char uuids
    class func from(gattCall: GattCall) -> XYServiceCharacteristic? {
        let serviceUuid = gattCall.serviceUuid.lowercased()
        let characteristicUuid = gattCall.characteristicUuid.lowercased()
        for (_, service) in self.registry {
            if let theService = service.values.first(
                where: { $0.serviceUuid.uuidString.lowercased() == serviceUuid &&
                    $0.characteristicUuid.uuidString.lowercased() == characteristicUuid }) {
                return theService
            }
        }

        return nil
    }
}

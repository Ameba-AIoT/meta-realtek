#!/bin/bash
SDK_DIR=$1

echo "remove $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/ieee802154"
rm -rf $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/ieee802154
sed -i '/ieee802154/d' $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/Kconfig
sed -i '/ieee802154/d' $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/Makefile

echo "remove $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/wireless/cfg80211_wifi"
rm -rf $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/wireless/cfg80211_wifi
sed -i '/cfg80211_wifi/d' $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/Kconfig
sed -i '/cfg80211_wifi/d' $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/Makefile

echo "remove $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/wireless/inic"
rm -rf $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/wireless/inic
sed -i '/inic/d' $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/Kconfig
sed -i '/inic/d' $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/Makefile

echo "remove $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/wireless/fullmac.readme"
rm -rf $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/wireless/fullmac.readme

echo "remove $SDK_DIR/sources/kernel/linux-5.4/arch/arm/boot/dts/rtl8730elh-va7-ranging.dts"
rm -rf $SDK_DIR/sources/kernel/linux-5.4/arch/arm/boot/dts/rtl8730elh-va7-ranging.dts

function keygen() {
    local certs_dir=~/.android-certs
    [ -z "$1" ] || certs_dir=$1
    rm -rf "$certs_dir"
    mkdir -p "$certs_dir"
    local subject
    echo "Sample subject: '/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN=Android/emailAddress=android@android.com'"
    echo "Now enter subject details for your keys:"
    for entry in C ST L O OU CN emailAddress; do
        echo -n "$entry:"
        read -r val
        subject+="/$entry=$val"
    done

    for cert in releasekey bluetooth cyngn-app media networkstack platform sdk_sandbox shared testcert testkey verifiedboot verity; do \
        ./development/tools/make_key ~/.android-certs/$cert "$subject"; \
    done

    cp ./development/tools/make_key ~/.android-certs/
    sed -i 's|2048|4096|g' ~/.android-certs/make_key

    for apex in com.android.adbd com.android.adservices com.android.adservices.api com.android.appsearch com.android.art com.android.bluetooth com.android.btservices com.android.cellbroadcast com.android.compos com.android.connectivity.resources com.android.conscrypt com.android.extservices com.android.hotspot2.osulogin com.android.i18n com.android.ipsec com.android.media com.android.media.swcodec com.android.mediaprovider com.android.nearby.halfsheet com.android.networkstack.tethering com.android.neuralnetworks com.android.ondevicepersonalization com.android.os.statsd com.android.permission com.android.resolv com.android.runtime com.android.safetycenter.resources com.android.scheduling com.android.sdkext com.android.support.apexer com.android.telephony com.android.tethering com.android.tzdata com.android.uwb com.android.uwb.resources com.android.virt com.android.vndk.current com.android.wifi com.android.wifi.dialog com.android.wifi.resources com.qorvo.uwb; do \
    ~/.android-certs/make_key ~/.android-certs/$apex "$subject"; \
    openssl pkcs8 -in ~/.android-certs/$apex.pk8 -inform DER -out ~/.android-certs/$apex.pem; \
done
}

keygen

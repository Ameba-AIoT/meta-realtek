FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-fix-neon_tensor_utils-compile-error.patch \
"

TF_ARGS_EXTRA += " \
    --define tflite_with_xnnpack=false \
    --define tflite_with_ruy=true \
"

do_compile () {
    export CT_NAME=$(echo ${HOST_PREFIX} | rev | cut -c 2- | rev)
    unset CC

    ${BAZEL} build \
        ${CUSTOM_BAZEL_FLAGS} \
        --copt -DTF_LITE_DISABLE_X86_NEON --copt -DMESA_EGL_NO_X11_HEADERS \
        third_party/eigen3:install_eigen_headers \
        tensorflow/lite:libtensorflowlite.so \
        tensorflow/lite/tools/benchmark:benchmark_model \
        //tensorflow/lite/examples/label_image:label_image \
        ${TF_TARGET_EXTRA}

    # build pip package
    ${S}/tensorflow/lite/tools/pip_package/build_pip_package_with_bazel.sh

}

do_install() {
    install -d ${D}${libdir}
    install -m 644 ${S}/bazel-bin/tensorflow/lite/libtensorflowlite.so \
        ${D}${libdir}

    # install tensorflow headers
    install -d ${D}${includedir}/tensorflow/lite
    install -d ${D}${includedir}/tensorflow/lite/internal
    install -d ${D}${includedir}/tensorflow/lite/c
    install -d ${D}${includedir}/tensorflow/lite/profiling
    install -d ${D}${includedir}/tensorflow/lite/kernels
    install -d ${D}${includedir}/tensorflow/lite/schema
    install -d ${D}${includedir}/tensorflow/lite/core
    install -d ${D}${includedir}/tensorflow/lite/core/api
    install -d ${D}${includedir}/tensorflow/lite/experimental/resource

    install -m 755 ${S}/tensorflow/lite/*.h ${D}${includedir}/tensorflow/lite
    install -m 755 ${S}/tensorflow/lite/internal/*.h ${D}${includedir}/tensorflow/lite/internal
    install -m 755 ${S}/tensorflow/lite/c/*.h ${D}${includedir}/tensorflow/lite/c
    install -m 755 ${S}/tensorflow/lite/profiling/*.h ${D}${includedir}/tensorflow/lite/profiling
    install -m 755 ${S}/tensorflow/lite/kernels/*.h ${D}${includedir}/tensorflow/lite/kernels
    install -m 755 ${S}/tensorflow/lite/schema/*.h ${D}${includedir}/tensorflow/lite/schema
    install -m 755 ${S}/tensorflow/lite/core/*.h ${D}${includedir}/tensorflow/lite/core
    install -m 755 ${S}/tensorflow/lite/core/api/*.h ${D}${includedir}/tensorflow/lite/core/api
    install -m 755 ${S}/tensorflow/lite/experimental/resource/*.h ${D}${includedir}/tensorflow/lite/experimental/resource

    # install flatbuffers headers
    install -d ${D}${includedir}/flatbuffers
    install -d ${D}${includedir}/flatbuffers/pch
    install -m 755 ${S}/../bazel/output_base/external/flatbuffers/include/flatbuffers/*.h ${D}${includedir}/flatbuffers
    install -m 755 ${S}/../bazel/output_base/external/flatbuffers/include/flatbuffers/pch/*.h ${D}${includedir}/flatbuffers/pch

    install -d ${D}${sbindir}
    install -m 755 ${S}/bazel-bin/tensorflow/lite/tools/benchmark/benchmark_model \
        ${D}${sbindir}

    #echo "Installing pip package"
    install -d ${D}/${PYTHON_SITEPACKAGES_DIR}
    ${STAGING_BINDIR_NATIVE}/pip3 install --disable-pip-version-check -v \
        -t ${D}/${PYTHON_SITEPACKAGES_DIR} --no-cache-dir --no-deps \
        ${S}/tensorflow/lite/tools/pip_package/gen/tflite_pip/python3/dist/tflite_runtime-${PV}-*.whl

}

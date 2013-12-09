LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
    Layer.cpp 								\
    LayerBase.cpp 							\
    LayerDim.cpp 							\
    LayerScreenshot.cpp						\
    DdmConnection.cpp						\
    DisplayHardware/DisplayHardware.cpp 	\
    DisplayHardware/DisplayHardwareBase.cpp \
    DisplayHardware/HWComposer.cpp 			\
    GLExtensions.cpp 						\
    MessageQueue.cpp 						\
    SurfaceFlinger.cpp 						\
    SurfaceTextureLayer.cpp 				\
    Transform.cpp 							\


LOCAL_CFLAGS:= -DLOG_TAG=\"SurfaceFlinger\"
LOCAL_CFLAGS += -DGL_GLEXT_PROTOTYPES -DEGL_EGLEXT_PROTOTYPES

ifeq ($(HAVE_FSL_IMX_IPU),true)
LOCAL_CFLAGS += -DFSL_IMX_DISPLAY
else ifeq ($(HAVE_FSL_IMX_GPU3D),true)
LOCAL_CFLAGS += -DFSL_IMX_DISPLAY
else ifeq ($(HAVE_FSL_IMX_GPU2D),true)
LOCAL_CFLAGS += -DFSL_IMX_DISPLAY
endif

ifeq ($(TARGET_BOARD_PLATFORM), omap3)
	LOCAL_CFLAGS += -DNO_RGBX_8888
endif
ifeq ($(TARGET_BOARD_PLATFORM), omap4)
	LOCAL_CFLAGS += -DHAS_CONTEXT_PRIORITY
endif
ifeq ($(TARGET_BOARD_PLATFORM), s5pc110)
	LOCAL_CFLAGS += -DHAS_CONTEXT_PRIORITY -DNEVER_DEFAULT_TO_ASYNC_MODE
	LOCAL_CFLAGS += -DREFRESH_RATE=56
endif

ifeq ($(HAVE_FSL_EPDC_FB),true)
LOCAL_CFLAGS += -DFSL_EPDC_FB
endif


LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libhardware \
	libutils \
	libEGL \
	libGLESv1_CM \
	libbinder \
	libui \
	libgui

ifeq ($(HAVE_FSL_IMX_IPU),true)
LOCAL_SHARED_LIBRARIES += libfsl_xmltool
else ifeq ($(HAVE_FSL_IMX_GPU3D),true)
LOCAL_SHARED_LIBRARIES += libfsl_xmltool
else ifeq ($(HAVE_FSL_IMX_GPU2D),true)
LOCAL_SHARED_LIBRARIES += libfsl_xmltool
endif
# this is only needed for DDMS debugging
LOCAL_SHARED_LIBRARIES += libdvm libandroid_runtime

LOCAL_C_INCLUDES := \
	$(call include-path-for, corecg graphics)

LOCAL_C_INCLUDES += hardware/libhardware/modules/gralloc
LOCAL_C_INCLUDES += external/expat/lib

LOCAL_MODULE:= libsurfaceflinger

include $(BUILD_SHARED_LIBRARY)

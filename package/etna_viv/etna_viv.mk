################################################################################
#
# etna_viv
#
################################################################################

# Last commit before source code was deprecated and moved to attic/
#  and galcore headers were made a submodule from another repo,
#  breaking building from fetched tarball.
ETNA_VIV_VERSION = 7f079cc0893331f68e8303e35bbded6a87807233

ETNA_VIV_SITE = $(call github,laanwj,etna_viv,$(ETNA_VIV_VERSION))
ETNA_VIV_INSTALL_STAGING = YES
# Currently, etna_viv only builds static libs, no point in installing those
# on the target.
ETNA_VIV_INSTALL_TARGET = NO

ifeq ($(BR2_PACKAGE_ETNA_VIV_ABIV2),y)
ETNA_VIV_ABI = v2
else ifeq ($(BR2_PACKAGE_ETNA_VIV_ABIV4),y)
ETNA_VIV_ABI = v4_uapi
else ifeq ($(BR2_PACKAGE_ETNA_VIV),y)
$(error No ABI version selected)
endif

define ETNA_VIV_BUILD_CMDS
	$(MAKE) -C $(@D)/src/etnaviv \
		GCCPREFIX="$(TARGET_CROSS)" \
		PLATFORM_CFLAGS="-D_POSIX_C_SOURCE=200809 -D_GNU_SOURCE -DLINUX" \
		PLATFORM_CXXFLAGS="-D_POSIX_C_SOURCE=200809 -D_GNU_SOURCE -DLINUX" \
		PLATFORM_LDFLAGS="-ldl -lpthread" \
		GCABI="$(ETNA_VIV_ABI)" \
		ETNAVIV_PROFILER=1
endef

define ETNA_VIV_INSTALL_STAGING_CMDS
	cp $(@D)/src/etnaviv/libetnaviv.a $(STAGING_DIR)/usr/lib
	mkdir -p $(STAGING_DIR)/usr/include/etnaviv
	cp $(@D)/src/etnaviv/*.h $(STAGING_DIR)/usr/include/etnaviv
endef

$(eval $(generic-package))

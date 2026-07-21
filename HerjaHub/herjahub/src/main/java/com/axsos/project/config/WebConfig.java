package com.axsos.project.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Autowired
	private RoleAccessInterceptor roleAccessInterceptor;

	@Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/uploads/**").addResourceLocations("file:uploads/");
    }

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(roleAccessInterceptor)
				.addPathPatterns("/customer/**", "/store/**")
				.excludePathPatterns("/store/api/**");
	}
}

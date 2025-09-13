package sn.isi.gestion_immobiliere.Filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class SecurityHeadersFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("=== INITIALISATION DU FILTRE DES EN-TÊTES DE SÉCURITÉ ===");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // CORRECTION: Ne pas appliquer les headers restrictifs aux images
        if (path.startsWith("/images/")) {
            // Headers spécifiques pour les images
            httpResponse.setHeader("X-Content-Type-Options", "nosniff");
            httpResponse.setHeader("Cache-Control", "public, max-age=3600");
            httpResponse.setHeader("Access-Control-Allow-Origin", "*");
            httpResponse.setHeader("Cross-Origin-Resource-Policy", "cross-origin");
        } else {
            // En-têtes de sécurité pour les autres ressources
            httpResponse.setHeader("X-Content-Type-Options", "nosniff");
            httpResponse.setHeader("X-Frame-Options", "DENY");
            httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
            httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

            // CSP plus permissif pour les images
            httpResponse.setHeader("Content-Security-Policy",
                    "default-src 'self'; " +
                            "script-src 'self' 'unsafe-inline' cdn.tailwindcss.com cdn.jsdelivr.net cdnjs.cloudflare.com; " +
                            "style-src 'self' 'unsafe-inline' cdn.jsdelivr.net cdnjs.cloudflare.com; " +
                            "font-src 'self' cdnjs.cloudflare.com; " +
                            "img-src 'self' data: blob:; " +
                            "connect-src 'self'");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("=== DESTRUCTION DU FILTRE DES EN-TÊTES DE SÉCURITÉ ===");
    }
}